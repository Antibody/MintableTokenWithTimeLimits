pragma solidity ^0.4.23;

import "./StandardToken.sol";
import "./Ownable.sol";

 
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Burn(address indexed from, uint256 value);

  bool public mintingFinished = false;
   
    string public name;
    string public symbol;
    uint8 public decimals = 0;
    

    

  modifier canMint() {
    require(!mintingFinished);
    _;
  }


 function getTime() public returns (uint256){                   // Returns current time. Check VISIBILITY (=> internal) 
        return now;
        
    }
    
    function mintUnlocked() internal returns (bool) {           // Checks if current time is greater than set time 
    // return (getTime() >= 1525094508);                           // 04/30/2018 @ 1:21pm (UTC) in this case
    return (getTime() >= 1525215600);                              // 05/01/2018 @ 11:00pm (UTC). This should not allow miniting today on April 30th
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
      
    require (mintUnlocked());
    
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
  
 
    
   /**
   * Gives name and symbol
   * Use " " with the string
   */
  constructor (
        string tokenName,
        string tokenSymbol,
        uint256 initialSupply
    ) public {
        name = tokenName;                                   
        symbol = tokenSymbol;
        totalSupply_ = initialSupply;
        balances[owner] = totalSupply_;
    }
    
  
    /**
   * This function allows to destroy tokens 
      */
        function burn(uint256 _value) public returns (bool success) {
        require(balances[owner] >= _value);   // Check if the sender has enough
        balances[owner] -= _value;            // Subtract from the sender
        totalSupply_ -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

   
}
