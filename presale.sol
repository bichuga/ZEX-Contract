pragma solidity 0.6.12;
import "./zexswap.sol";

contract ICO {
    using SafeMath for uint;
    
    ZexSwap public token;
    address public owner;
    bool isActive=false;
    
    //price of per token 
    uint pricePerToken=4000000000000000;

    uint public availableToken;
    uint MinPurchase=1000000000000000000;
    uint MaxPurchase=1000000000000000000000000;
    
    
    event Purchase(address from,uint _amount);
    
    constructor (ZexSwap _token,uint _availabletoken)public {
        
        token=_token;
        owner=msg.sender;
        availableToken=_availabletoken;
    }
    function startEnd() public onlyOwner{
        if (isActive==false){
            isActive=true;
        }else{
            isActive=false;
        }
        
    }
    
    function deposite() public payable {
         _transfer(msg.value);
        
    }
    
    //Function to receive plan ether & send the token equivalent to msg.value
    receive() external payable{
        _transfer(msg.value);
        
    }
    function _transfer(uint256 _msg) internal {
        require(isActive==true,"Presale has ended");
        uint256 sendvalue=_msg.div(pricePerToken);
        require(availableToken>=sendvalue,"Insufficent token");
        availableToken=availableToken.sub(sendvalue*1e18);
        token.transfer(msg.sender,sendvalue*MinPurchase);
        emit Purchase(msg.sender,sendvalue);
        
        
    }
    function withdrawEth(address payable _to,uint _amount) external onlyOwner{
        _to.transfer(_amount);
        
    }
    function WithdrawToken(uint _amount) external onlyOwner{
        
        ZexSwap(token).transfer(msg.sender,_amount);
    }
    function transferOwnership(address _owner) public{
        require(msg.sender==owner);
        owner=_owner;
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
    
    
}
