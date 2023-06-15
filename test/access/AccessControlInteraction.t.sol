// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {AccessControlInteraction} from "../../src/access/AccessControlInteraction.sol";

contract AccessControlInteractionTest is Test {
    event StudentGrade(address _studentAddress, uint256 _grade);
    event NewStudent(string _name, string _email, address _studentAddress);

    AccessControlInteraction public accessControlInteraction;

    function setUp() public {
        accessControlInteraction = new AccessControlInteraction();
        accessControlInteraction.grantRole(accessControlInteraction.GRADE_OFFICER(), address(1));
        accessControlInteraction.grantRole(accessControlInteraction.ADMISSION_OFFICER(), address(2));
    }

    function testFailToAdmitStudent() public {
        accessControlInteraction.admitStudent('Henry', 'henry@gmail.com', address(10));
    }

    function testFailToGradeStudent() public {
        accessControlInteraction.gradeStudent(address(10), 20);
    }
    
    function testAdmitStudent() public {
        vm.prank(address(2));

        accessControlInteraction.admitStudent('Henry', 'henry@gmail.com', address(10));
        (string memory name, string memory email, ) = accessControlInteraction.students(address(10));
        
        assertEq(name, 'Henry');
        assertEq(email, 'henry@gmail.com');
    }

    function testGradeStudent() public {
        vm.prank(address(1));
        accessControlInteraction.gradeStudent(address(10), 20);

        (,, uint256 grade ) = accessControlInteraction.students(address(10));
        assertEq(grade, 20);
    }

    function testEmitNewStudentEvent() public {
        vm.prank(address(2));
        vm.expectEmit(false, false, false, true);

        emit NewStudent('Tarik', 'tarik@gmail.com', address(11));
        accessControlInteraction.admitStudent('Tarik', 'tarik@gmail.com', address(11));
    }

    function testEmitStudentGradeEvent() public {
        vm.prank(address(1));
        vm.expectEmit(false, false, false, true);

        emit StudentGrade(address(11), 50);
        accessControlInteraction.gradeStudent(address(11), 50);
    }
}
