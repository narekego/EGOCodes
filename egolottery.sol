
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 < 0.9.0; // definition of the compiler version 

contract Lottery
{
//Global variables
    address             public deployer;                          //Variable for storing the deployers address
    address payable[]   public players;                          //Variable for storing player's addresses
    address payable[]   public winner;                           //Variable for storing the winner's address
    bool                       gameAllowed = true;
    uint16                     minPlayers = 1;
    uint72                     minEntry = 1000000000000000;


//Function modifiers restrict the execution of the function until the condition is met
    modifier restricted()       //only manager can execute a function
            {
            require(msg.sender == deployer, "Only deployer can draw");
            _;
            }
    modifier minimumPlayers()   //minumum number of participants
            {
            require(players.length >minPlayers, "Not enough players");
            _;
            }
    modifier minimumEth()       //minimum amount to enter the lottery
            {
            require(msg.value > minEntry, "Not enough tokens sent"); //0.01 eth
            _;
            }

//Functions
    constructor()          //This constructor function reads and assign the deployer address to the manager
            {
            deployer = msg.sender;
            }

    function allowGame(bool gameState)
        public
        restricted
            {
            gameAllowed = gameState;
            }

    function seMinPlayers(uint16 setMinPlayers)
        public
        restricted  
            {
            minPlayers = setMinPlayers;
            }

    function seMinimumEntry(uint72 setMinEntry)
        public
        restricted 
            {
            minEntry = setMinEntry;
            }

    receive()            //Function that allows receving >0.01 ETH into the contract  
        external
        payable
            {
            require(gameAllowed == true, "Game is not live");
            require(msg.value > minEntry, "Minimum is 0.01 ETH"); //0.01 eth
            players.push(payable(msg.sender));
            }

    function ShowAll()          //Function that shows all participants
        public
        view
        returns(address payable[] memory)
            {
            return players;
            }

    function PlayersNo()        //Function that shows the total number of participants
        public
        view
        returns(uint)
            {
            return players.length;
            }
    function Random()           //Function generates pseudo random number, never specified exact time prior to a draw to make it random. Maybe give 2 minutes range.
        private
        view
        returns(uint)
            {
            return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players)));
            }

    function PickWinner()       //FUnction picks the winner's wallet, sends the rewards ballance to the wallet and resets the players array
        public
        restricted
        minimumPlayers
            {
            //winner = new address payable[] (0); 
            
            uint index = Random() % players.length;
            //uint i_second;
            //uint i_third;
            
            
            /*do
                {
                i_second = Random() % players.length;
                }
            while(i_second != i_first);*/

            //players[index].transfer(address(this).balance);
            //winner = players[index];

            //players = new address payable[](0);     

            //uint tax =       address(this).balance * 15 / 100;
            uint first  =    address(this).balance * 85 / 100;
            //uint second =    address(this).balance * 20 / 100;
            //uint third =     address(this).balance *  5 / 100;
            address payable temp = players[index];
            winner.push(temp);
            players[index].transfer(first);
            //winner[1].transfer(second);
            //winner[2].transfer(third);     
            players = new address payable[](0);          
            }

    function sendRewards()
        public
            {
            
            }

    function ShowWinner()       //Function shows the winner
        public
        view
        returns(address)
            {
            return winner[0]; 
            }
    function Show2nd()       //Function shows the 2nd
        public
        view
        returns(address)
            {
            return winner[1];
            }
    function Show3rd()       //Function shows the 3rd
        public
        view
        returns(address)
            {
            return winner[2];
            }
    
    function showbalance()
        public
        view
        returns(uint)
            {
            return address(this).balance;
            }
}