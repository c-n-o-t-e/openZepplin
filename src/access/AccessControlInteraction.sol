// SPDX-License-Identifier: UNLICENSED

/**
 * Created on 2023-06-14 19:08
 * @Summary A smart contract that lets adminstration grant grades based on the role they hold
 * @title AccessControlInteraction
 * @author: c-n-o-t-e
 */

pragma solidity >=0.8.19;

import {IAccessControlInteraction} from "./Interfaces/IAccessControlInteraction.sol";
import {AccessControl} from "openzeppelin-contracts/contracts/access/AccessControl.sol";

contract AccessControlInteraction is AccessControl, IAccessControlInteraction {
    bytes32 public constant GRADE_OFFICER = keccak256("GRADE_OFFICER");
    bytes32 public constant ADMISSION_OFFICER = keccak256("ADMISSION_OFFICER");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    struct StudentInfo{
        string name;
        string email;
        uint256 grade;
    }

    mapping(address => StudentInfo) public students;

    /// @inheritdoc IAccessControlInteraction
    function admitStudent(string memory _name, string memory _email) external onlyRole(ADMISSION_OFFICER) {
        StudentInfo storage student = students[_msgSender()];
        student.name = _name;
        student.email = _email;
        emit NewStudent(_name, _email);
    }

    /// @inheritdoc IAccessControlInteraction
    function gradeStudent(address _studentAddress, uint _grade) external onlyRole(GRADE_OFFICER) {
        students[_studentAddress].grade = _grade;
        emit StudentGrade(_studentAddress, _grade);
    }
}
