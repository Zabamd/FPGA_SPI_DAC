----------------------------------------------------------------------------------
-- Engineer: Amadeusz Zabierowski, 255624 
-- Create Date: 03/19/2023 08:12:10 PM
-- Project Name: SPI Master Controller
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity spi_controller is
    port(
        RESET, CLK : in std_logic;
        enable_transmition : in std_logic;
        operation_type : in std_logic; -- 0 for write, 1 for read         
        
        --data transmition channels
        miso : in std_logic;
        mosi : out std_logic;

        --master controll channels
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
signal memory_counter : std_logic_vector(23 downto 0) <=  ( others => 0 );

begin

memory_count : process( RESET, CLK ) is
begin
    if( RESET = 1) then
        memory_counter <= ( others => 0 );
    elsif ( CLK'event and CLK = '1' ) then 
        memory_counter <= memory_counter + 1 ;
    end if;
end process memory_count;

state_transition : process( RESET, CLK ) is
begin
    if( RESET = 1) then
        current_state <= idle;
        next_state <= idle
    elsif ( CLK'event and CLK = '1' ) then 
        current_state <= next_state ;
    end if;
end process state_transition;

basic_transitions: process(next_state, current_state) is
begin
    next_state <= current_state;
    
    case current_state is
        when idle =>
            if( enable_transmition = 1 ) then
                if( operation_type = 1 ) then
                    next_state <= recieve;
                else
                    next_state <= transmit;
                end if;
            end if;
        when recieve or transmit  =>
            if( memory_counter = "11111111111111111111111" ) then
                next_state <= comm_stop;
            end if;
        when  comm_stop =>
            next_state <= idle;
    end case;
end process basic_transitions; 

recieve_data : process( CLK ) then
begin 
    if( CLK'event and CLK = 1 ) then
        inner_memory <= inner_memory(inner_memory'high - 1 downto inner_memory'low ) & miso;
    end if;
end process recieve_data;


end architecture behavioral;

