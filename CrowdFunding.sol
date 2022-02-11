//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;


contract CrowdFunding{

    mapping(address => uint) public contributers;
    address public admin;
    uint public noOfContributers;
    uint public minimumContributer;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;

    struct Request{
        string description;
        address payable recipient;
        uint value;     
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numRequests;


     



    constructor (uint _goal, uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContributer = 100 wei;
        admin = msg.sender;
    } 


    event ContributeEvent(address _sender, uint _value);
    event createRequestEvent(string _description, address _requestNo, uint _value);
    event makePaymentEvent(address _requestNo, uint _value);


    function contribute() public payable{
           require(block.timestamp < deadline, "Deadline has passed");
           require(msg.value >= minimumContributer,"Minimum Contribution not met");

           if(contributers[msg.sender] == 0){
               noOfContributers ++;
           }
           contributers[msg.sender] += msg.value;
           raisedAmount += msg.value;
           emit ContributeEvent(msg.sender, msg.value);

    }

    modifier onlyAdmin(){
        require(admin == msg.sender,"You are not Admin");
        _;
    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }


    function getRefund() public{
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributers[msg.sender] > 0);

        address payable recipient = payable(msg.sender);
        uint value = contributers[msg.sender];
        recipient.transfer(value);   

       // payable(msg.sender).transfer(contributers[msg.sender]);
        contributers[msg.sender] = 0;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin{
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
        
        emit createRequestEvent(_description,_recipient,_value);


    }

        function voteRequest(uint _requestNo) public{
            require(contributers[msg.sender] > 0,"You must be a contributer to vote");
            Request storage thisRequest = requests[_requestNo];
            require(thisRequest.voters[msg.sender] == false, "You have already voted!");
            thisRequest.voters[msg.sender] = true;
            thisRequest.noOfVoters++;
        }

        function makePayment(uint _requestNo) public onlyAdmin {
        require(raisedAmount >= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false,"The Request has been completed");
        require(thisRequest.noOfVoters > thisRequest.noOfVoters/2 );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit makePaymentEvent(thisRequest.recipient, thisRequest.value);
        }

}