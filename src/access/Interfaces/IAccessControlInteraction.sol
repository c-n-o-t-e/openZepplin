// SPDX-License-Identifier: UNLICENSED

/**
 * @dev External interface of AccessControlInteraction.
 */
interface IAccessControlInteraction {
    /**
     * @dev Emits when a new student is admitted.
     */
    event NewStudent(string _name, string _email);

    /**
     * @dev Emits when a student gets graded.
     */
    event StudentGrade(address _studentAddress, uint256 _grade);

    function admitStudent(string memory _name, string memory _email, address _studentAddress) external;

    function gradeStudent(address _studentAddress, uint _grade) external;
}