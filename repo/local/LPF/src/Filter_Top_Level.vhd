-------------------------------------------------------------------------------
--
-- File: Filter_Top_Level.vhd
-- Author: Tudor Gherman
-- Original Project: low_level_zmod_adc_dac
-- Date: 19 February 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright Digilent Incorporated
-- All Rights Reserved
-- 
-- This program is free software; distributed under the terms of BSD 3-clause 
-- license ("Revised BSD License", "New BSD License", or "Modified BSD License")
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this
--    list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
-- 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
--    of its contributors may be used to endorse or promote products derived
--    from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-------------------------------------------------------------------------------
--
--This module implements a digital low pass filter based on the Xilinx's FIR 
--Compiler with a input sampling rate 100 times lower than the system clock. 
--The filter's output is available on the sysDacCh1 output port. The input
--(sysAdcCh1) is looped back on the sysDacCh2 output port. 
 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Filter_Top_Level is
    Port ( SysClk : in STD_LOGIC;
           sysRst_n : in STD_LOGIC;
           sysInitAdcDone : in STD_LOGIC;
           sysInitDacDone : in STD_LOGIC;
           sysAdcCh1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
           sysDacCh1 : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
           sysDacCh2 : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
         );
end Filter_Top_Level;

architecture Behavioral of Filter_Top_Level is

COMPONENT fir_compiler_0
  PORT (
    aresetn : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

signal sysSlvAxisTvalid: std_logic;
signal sysSlvAxisTready: std_logic;
signal sysMstrAxisTvalid: std_logic;
signal aResetFilter_n: std_logic;
signal sysDacCh1_16b: std_logic_vector(15 downto 0);
signal sysCounter : std_logic_vector(7 downto 0);


begin

aResetFilter_n <= (not sysInitAdcDone) and (not sysInitDacDone) and sysRst_n;

sysCounter_PROC: process (SysClk)  
begin
    if (SysClk' event and SysClk = '1') then
        if (sysRst_n = '0') then
            sysCounter <= (others => '0');
        else
            if (sysCounter = x"63") then
                sysCounter <= (others => '0');
            else
                sysCounter <= sysCounter + '1';
            end if;    
        end if;
    end if;
end process;

TVALID1_PROC: process (SysClk)  
begin
    if (SysClk' event and SysClk = '1') then
        if (sysRst_n = '0') then
            sysSlvAxisTvalid <= '0';
        else
            if (sysCounter = x"63") then
                sysSlvAxisTvalid <= '1';
            else
                if(sysSlvAxisTready = '1') then
                   sysSlvAxisTvalid <= '0';
                end if;
            end if;    
        end if;
    end if;
end process;
      
CH1_Filter : fir_compiler_0
  PORT MAP (
    aresetn => aResetFilter_n,
    aclk => SysClk,
    s_axis_data_tvalid => sysSlvAxisTvalid,
    s_axis_data_tready => sysSlvAxisTready,
    s_axis_data_tdata => sysAdcCh1,
    m_axis_data_tvalid => sysMstrAxisTvalid,
    m_axis_data_tdata => sysDacCh1_16b
  );
  
  sysDacCh2 <= sysAdcCh1(15 downto 2); 
  sysDacCh1 <= sysDacCh1_16b(15 DOWNTO 2);

end Behavioral;
