----------------------------------------------------------------------------------
-- Engineer: 
-- Create Date: 03/19/2023 08:12:10 PM
-- Project Name: 
-- Description: 
-- Dependencies: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity spi_controller is
    port(
        RESET, CLK : in std_logic;
        
        enable_transmition : in std_logic;
        operation_type : in std_logic;
        
        --transmition channels
        miso : in std_logic;
        mosi : out std_logic;

        master_clk : out std_logic; 
        chip_select : out std_logic;
    );
end entity spi_controller;

architecture behavioral of spi_controller is

--State Declaration
type spi_master_states is ( idle, transmit, recieve, comm_stop );
signal current_state : spi_master_states <= idle;
signal next_state : spi_master_states <= idle; 

--Memory
signal inner_memory : std_logic_vector(23 downto 0) <= ( others => 0 );
--Counter up to 24 bits in memory
signal mem_counter : std_logic_vector(4 downto 0) <= "11000";

begin

mem_count : process( RESET, CLK ) is
begin
    if( RESET = 1) then
        mem_counter <= ( others => 0 );
    elsif ( CLK'event and CLK = '1' ) then 
        mem_counter <= mem_counter + 1 ;
    end if;
end process mem_count;

end architecture behavioral;

