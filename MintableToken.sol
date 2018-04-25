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
    uint8 public decimals = 0;  //Don't FORGET to change 
    

    

  modifier canMint() {
    require(!mintingFinished);
    _;
  }


  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
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
   * Use "" with string
   */
  constructor (
        string tokenName,
        string tokenSymbol
    ) public {
        name = tokenName;                                   
        symbol = tokenSymbol;                              
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

    /**
     * Destroy tokens from other account
     * NOT SURE IF NEEDED
     *  SMTH LIKE This:
     *  function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                
        require(_value <= allowance[_from][msg.sender]);    
        balances[_from] -= _value;                         
        allowance[_from][owner] -= _value;             
        totalSupply_ -= _value;                              
        emit Burn(_from, _value);
        return true;
    }
     */
   
}
