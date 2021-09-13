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
use ieee.numeric_std.all;

entity Filter_Top_Level is
   Generic (
      -- 
      kDecimFactor : integer := 99
   );
   Port ( 
      SamplingClk : in STD_LOGIC;
      aRst_n : in STD_LOGIC;
      sInitDoneADC : in STD_LOGIC;
      sInitDoneDAC : in STD_LOGIC;
      sInitDoneRelay : in STD_LOGIC;
      -- AXI Stream (master) data interface
      cInAxisTvalid: IN STD_LOGIC;
      cInAxisTready: OUT STD_LOGIC;
      cInAxisTdata: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      cOutAxisTvalid: OUT STD_LOGIC;
      cOutAxisTready: IN STD_LOGIC;
      cOutAxisTdata: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)      
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

signal cSlvAxisTvalid: std_logic;
signal cSlvAxisTready: std_logic;
signal aResetFilter_n, acRst_n: std_logic;
signal cDacCh1_16b: std_logic_vector(15 downto 0);
signal cCounter : unsigned(7 downto 0);


begin

aResetFilter_n <= sInitDoneADC and sInitDoneDAC and aRst_n and sInitDoneRelay;
cInAxisTready <= '1';

InstSysReset : entity work.ResetBridge
   Generic map(
      kPolarity => '0')
   Port map(
      aRst => aResetFilter_n, 
      OutClk => SamplingClk,
      oRst => acRst_n);
      
sysCounter_PROC: process (SamplingClk)  
begin
   if (acRst_n = '0') then
      cCounter <= (others => '0');
   elsif (rising_edge(SamplingClk)) then
      if (cCounter = (to_unsigned(kDecimFactor,8))) then
         cCounter <= (others => '0');
      else
         cCounter <= cCounter + 1;
      end if;    
   end if;
end process;

TVALID1_PROC: process (SamplingClk)  
begin
   if (acRst_n = '0') then
      cSlvAxisTvalid <= '0';
   elsif (rising_edge(SamplingClk)) then
      if (cCounter = (to_unsigned(kDecimFactor,8))) then
         cSlvAxisTvalid <= '1';
      else
         if(cSlvAxisTready = '1') then
            cSlvAxisTvalid <= '0';
         end if;
      end if;    
   end if;
end process;
      
CH1_Filter : fir_compiler_0
  PORT MAP (
    aresetn => acRst_n,
    aclk => SamplingClk,
    s_axis_data_tvalid => cSlvAxisTvalid,
    s_axis_data_tready => cSlvAxisTready,
    s_axis_data_tdata => cInAxisTdata(31 downto 16),
    m_axis_data_tvalid => cOutAxisTvalid,
    m_axis_data_tdata => cDacCh1_16b
  );

cOutAxisTdata <= cDacCh1_16b & cInAxisTdata(31 downto 16); 

end Behavioral;
