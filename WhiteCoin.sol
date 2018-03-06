pragma solidity ^ 0.4 .19;

contract ERC223ReceivingContract { 
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenFallback(address _from, uint _value, bytes _data);
    function tokenFallback(address _from, uint _value, bytes _data, string _stringdata, uint256 _numdata );
    
}


contract tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns(uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


contract ERC20 {

   function totalSupply() constant returns(uint totalSupply);

    function balanceOf(address who) constant returns(uint256);

    function transfer(address to, uint value) returns(bool ok);

    function transferFrom(address from, address to, uint value) returns(bool ok);

    function approve(address spender, uint value) returns(bool ok);

    function allowance(address owner, address spender) constant returns(uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

}


contract WhiteCoin is ERC20  {

    using SafeMath
    for uint256;
    /* Public variables of the token */
    string public standard = 'WHITE 1.0';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public initialSupply;
    bool initialize;
    address public manager;

    mapping( address => uint256) public balanceOf;
    mapping( address => mapping(address => uint256)) public allowance;
    
    mapping ( address => bool ) public minter;
    mapping ( uint => address ) public minterList;
    uint public minterCount;


    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
    event Transfer(address indexed from, address indexed to, uint value, bytes data, string _stringdata, uint256 _numdata );
    event Approval(address indexed owner, address indexed spender, uint value);

    /* This notifies clients about the amount burnt */
    event Burn(address indexed from, uint256 value);
    event Minted(address indexed from, uint256 value);
    
    
    
    modifier onlyManager() {
        
        require ( msg.sender == manager ) ;
        _;
        
    }
       
    modifier onlyMinter() {
        
        require ( isMinter( msg.sender ) ) ;
        _;
        
    }

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function WhiteCoin() {

        uint256 _initialSupply = 1000000000000 ; 
        uint8 decimalUnits = 8;
        balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
        totalSupply = _initialSupply; // Update total supply
        initialSupply = _initialSupply;
        name = "WHITE"; // Set the name for display purposes
        symbol = "WHITE"; // Set the symbol for display purposes
        decimals = decimalUnits; // Amount of decimals for display purposes
        manager = msg.sender;
        
        
    }

   
   function isMinter( address _address )returns(bool){
       
       if ( minter[ _address] ) return true;
       return false;
       
   }
   
   function addMinter ( address _address ) onlyManager {
       
      minter[ _address ] = true;
       
   }
   
   
   function removeMinter ( address _address ) onlyManager {
       
      minter[ _address ] = false;
       
   }
   

    function balanceOf(address tokenHolder) constant returns(uint256) {

        return balanceOf[tokenHolder];
    }

    function totalSupply() constant returns(uint256) {

        return totalSupply;
    }


    function transfer(address _to, uint256 _value) returns(bool ok) {
        
        if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
        bytes memory empty;
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        
        Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
        return true;
    }
    
     function transfer(address _to, uint256 _value, bytes _data ) returns(bool ok) {
        
        if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
        bytes memory empty;
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        
        Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata ) returns(bool ok) {
        
        if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
        bytes memory empty;
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data, _stringdata, _numdata);
        }
        
        Transfer(msg.sender, _to, _value, _data , _stringdata, _numdata ); // Notify anyone listening that this transfer took place
        return true;
    }
    
    
    function isContract( address _to ) internal returns ( bool ){
        
        
        uint codeLength = 0;
        
        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }
        
         if(codeLength>0) {
           
           return true;
           
        }
        
        return false;
        
    }
    
    
    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value)
    returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval( msg.sender ,_spender, _value);
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
    returns(bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
        return allowance[_owner][_spender];
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
        
        if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[_from] < _value) throw; // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw; // Check allowance
        balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
        Transfer(_from, _to, _value);
        return true;
    }
  
    function burn(uint256 _value) returns(bool success) {
        
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
        if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
        balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
        totalSupply = totalSupply.sub( _value ); // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

   function burnFrom(address _from, uint256 _value) returns(bool success) {
        
        if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[_from] < _value) throw; 
        if (_value > allowance[_from][msg.sender]) throw; 
        balanceOf[_from] = balanceOf[_from].sub( _value ); 
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
        totalSupply = totalSupply.sub( _value ); // Updates totalSupply
        Burn(_from, _value);
        return true;
    }
    
    
    function mintWhitecoin( uint256 _amount ) onlyMinter returns(bool success) {
        
        
        if ( _amount == 0 ) throw; 
        
        balanceOf[msg.sender] = balanceOf[msg.sender].add( _amount ); // add minted tokens to Minters account
        totalSupply = totalSupply.add( _amount ); // Updates totalSupply
        Minted(msg.sender, _amount);
        return true;
    }
   

    function transferManager ( address _manager ) onlyManager {
        
        manager = _manager;
        
        
    }
    
}
