// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";
 contract SlrAirdrop{
      ERC20 public Token;
      bool public airdrop=false;
      address public owner;
       event MultiERC20Transfer(
        address indexed _from,
        uint indexed _value,
        address _to,
        uint _amount,
        ERC20 _token
    );
    event Airdrop(uint amount);
    event ChangeToken(ERC20 token);
      constructor(address _adreessToken){
          Token=ERC20(_adreessToken);
          owner=msg.sender;
      }
    function changeToken(address _newToken) public onlyOwner(){
        Token=ERC20(_newToken);
        emit ChangeToken(ERC20(_newToken));
    }
       modifier onlyOwner() {
        require(_owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
      }
      function _msgSender() internal view virtual returns (address) {
        return msg.sender;
      }
      function _owner() public view virtual returns (address) {
        return owner;
      }

      function airdropOff() public onlyOwner{
          airdrop=false;
      }
      function airdropOn() public onlyOwner{
          airdrop=true;
      }
      function allValues(uint[] calldata amounts) public pure returns(uint){
        uint amount = 0;
        for(uint i=0;i<amounts.length;i++){
          amount+= amounts[i];
        }
        return amount;
      }

      function AddressConfirmation(address[] calldata users) public pure returns(bool){
        bool conf = true;
        for(uint i=0;i<users.length;i++) if(users[i]== address(0)) {conf=false;break;}
        return conf;
      }


      function transferOwnership(address newOwner) public onlyOwner {
         require(newOwner != address(0),"this new address Incorrect");
         owner = newOwner;
      }

      function airdropERC20(address[] calldata users ,uint[] calldata value) public onlyOwner{
          require(airdrop,"airdrop is paused");
          require(allValues(value)<=Token.balanceOf(_owner()),"Balance of owner not enough");
          require(users.length == value.length,"The number of beneficiaries differs from the number of salaries");
          require(AddressConfirmation(users),"Some address are not accepted");
          for(uint i=0;i<users.length;i++){
             _safeTransferFrom(Token,_owner(),users[i],value[i]);
          }
          emit Airdrop(allValues(value));
      }


      function _safeTransferFrom(
        ERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        require(sender != address(0),"address of sender Incorrect ");
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
 }
