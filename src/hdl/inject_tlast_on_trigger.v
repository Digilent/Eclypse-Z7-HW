`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc
// Engineer: Arthur Brown
// 
// Create Date: 05/19/2022 01:35:04 PM
// Design Name: 
// Module Name: inject_tlast_on_trigger
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//    when a trigger occurs, starts counting beats, once a specified number of beats has passed (trigger_to_last_delay)
//    asserts tlast on the master interface, stops counting, and raises the done flag until it is acknowledged
//
//    in order to ensure the consecutive-ness of data, while waiting on done acknowledge signal, all pending transfers are discarded 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inject_tlast_on_trigger (
    input  wire        stream_clk,
    input  wire        stream_resetn,
    
    // trigger input port in the axi4-stream slave's clock domain
    input  wire [31:0] trigger, // 32 trigger input bits
    
    //software register ports
    input  wire [31:0] trigger_enable, // used to mask the trigger inputs, intended to be connected to a software-controlled reg
    input  wire [31:0] trigger_to_last_beats, // number of beats between trigger signal and tlast, such that the address of the tlast data beat is trigger_to_last_beats plus the address of the trigger beat 
    output wire        idle, // done status, indicating a trigger has occurred and a last beat issued 
    input  wire        start, // acknowledges the done status, returns hardware to prebuffering, if reconfiguring this between acquisitions is required, 
    output wire [31:0] trigger_detected, // software-readable register storing the actual trigger condition that occurred for the last transfer  
    input  wire [31:0] prebuffer_beats, // number of beats that need to be prebuffered before the trigger is can occur. Includes the trigger beat.
    // note: the sum of prebuffer_beats and trigger_to_last_beats must be greater than or equal to the software circle buffer size in words
    
    // axi4-stream slave interface, always active
    //    tvalid should not be asserted until after this module is configured 
    input  wire [31:0] s_tdata,
    input  wire        s_tvalid,
    output wire        s_tready,
    
    // axi4-stream master interface, active in await and counting states
    //    to ensure data consecutiv-ity, downstream must be capable of handling the full bandwidth of the slave interface.   
    output wire [31:0] m_tdata,
    output wire        m_tvalid,
    input  wire        m_tready,
    output wire        m_tlast,
    
    output wire [1:0] dbg_state
);    
    // control state machine
    localparam S_IDLE = 0; // wait for start signal assert, then go to prebuffer
    localparam S_PREBUFFER = 1; // enable output stream and transmit 'prebuffer_beats' data beats, then go to await
    localparam S_AWAIT = 2; // wait for trigger condition, masked by enable signals, then go to counting
    localparam S_COUNTING = 3; // transmit 'trigger_to_last_beats' data beats to fill the remainder of a buffer, then go back to idle
    localparam C_STATES = 4;
    
    wire data_beat;
    wire [31:0] beat_count;
    wire next_tlast;
    wire any_trigger;
    wire [$clog2(C_STATES-1)-1:0] state;
    reg  [$clog2(C_STATES-1)-1:0] next_state;
    wire axis_m_output_enable;
    wire tlast_reg_enable;
    wire counter_enable;
    wire trigger_masked;
    wire counter_reset;
    
    assign dbg_state = state;
    
    assign axis_m_output_enable = (state != S_IDLE);
    assign m_tvalid = (axis_m_output_enable) ? s_tvalid : 'b0;
    assign m_tdata = (axis_m_output_enable) ? s_tdata : 'b0;
    assign data_beat = m_tvalid & m_tready;
    assign s_tready = 1'b1;
    
    assign counter_enable = (state == S_COUNTING || state == S_PREBUFFER) & data_beat;
    assign counter_reset = (state != S_COUNTING && state != S_PREBUFFER);
    assign tlast_reg_enable = (state == S_COUNTING) & data_beat;
    
    assign any_trigger = (state == S_AWAIT) & |(trigger & trigger_enable);
    assign trigger_masked = trigger & trigger_enable;
    
    assign idle = (state == S_IDLE);
    
    always @(*) begin
        case (state)
        S_IDLE: begin
            if (start) begin
                next_state = S_PREBUFFER;
            end else begin
                next_state = state;
            end
        end
        S_PREBUFFER: begin
            if (beat_count == prebuffer_beats - 2) begin
                next_state = S_AWAIT;
            end else begin
                next_state = state;
            end
        end
        S_AWAIT: begin
            if (any_trigger) begin
                next_state = S_COUNTING;
            end else begin
                next_state = state;
            end
        end
        S_COUNTING: begin
            if (data_beat && m_tlast) begin
                next_state = S_IDLE;
            end else begin
                next_state = state;
            end
        end
        default: next_state = 0;
        endcase
    end
    
    register #(
        .RESET_VALUE  (S_IDLE),
        .WIDTH        ($clog2(C_STATES-1))
    ) state_reg_inst (
        .clock        (stream_clk),
        .reset        (~stream_resetn),
        .write_enable (1'b1),
        .data_i       (next_state),
        .data_o       (state)
    );
    
    counter #(
        .HIGH         (32'hFFFFFFFF)
    ) beat_counter_inst (
        .clock        (stream_clk),
        .clock_enable (1'b1),
        .sync_reset   (~stream_resetn | counter_reset),
        .enable       (counter_enable),
        .count        (beat_count),
        .tc           ()
    );
    
    // trigger_to_last_beats equal to 0 or 1 not supported. this means that a trigger cannot occur on either the final or second-to-last beat of an acquisition
    assign next_tlast = (beat_count == trigger_to_last_beats - 2);
    
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (1)
    ) m_tlast_reg_inst (
        .clock        (stream_clk),
        .reset        (~stream_resetn),
        .write_enable (tlast_reg_enable),
        .data_i       (next_tlast),
        .data_o       (m_tlast)
    );
    
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (32)
    ) trigger_detected_reg_inst (
        .clock        (stream_clk),
        .reset        (~stream_resetn),
        .write_enable (any_trigger),
        .data_i       (trigger_masked),
        .data_o       (trigger_detected)
    );
endmodule
