//
//  ConfirmCreateRequestLeaveViewController.swift
//  wsm
//
//  Created by framgia on 10/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize
import ObjectMapper

class ConfirmCreateRequestLeaveViewController: NoMenuBaseViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var confirmItems = [ConfirmRequestItem]()
    var requestModel = RequestLeaveApiInputModel()
    var leaveType: LeaveTypeModel?
    let currentUser = UserServices.getLocalUserProfile()
    let compensationRowNumber = 3


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        appendDefaultItem()
        appendTrackingItem()
        appendCompensationItem()
    }

    func appendDefaultItem() {

        var branchName = ""
        if let branches = currentUser?.workSpaces, let i = branches.index(where: {$0.id == requestModel.workspaceId}) {
            branchName = branches[i].name ?? ""
        }
        var groupName = ""
        if let groups = currentUser?.groups, let i = groups.index(where: {$0.id == requestModel.groupId}) {
            groupName = groups[i].fullName ?? ""
        }
        if let leaveTypes = UserServices.getLocalLeaveTypeSettings(), let i = leaveTypes.index(where: {$0.id == requestModel.leaveTypeId}) {
            leaveType = leaveTypes[i]
        }

        confirmItems.append(ConfirmRequestItem(imageName: "ic_placeholder_user",
                                               header: LocalizationHelper.shared.localized("employee_name"),
                                               value: currentUser?.name))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_id_card",
                                               header: LocalizationHelper.shared.localized("employee_code"),
                                               value: currentUser?.employeeCode))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_branch",
                                               header: LocalizationHelper.shared.localized("branch"),
                                               value: branchName))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_group",
                                               header: LocalizationHelper.shared.localized("group"),
                                               value: groupName))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("project_name"),
                                               value: requestModel.projectName))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("type_leave"),
                                               value: leaveType?.name))
    }

    func appendTrackingItem() {
        if let trackingType = leaveType?.trackingTimeType {
            switch trackingType {
            case .both:
                confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("from"),
                                                       value: requestModel.checkinTime))
                confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("to"),
                                                       value: requestModel.checkoutTime))
            case .checkOut:
                confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("title_forgot_out"),
                                                       value: requestModel.checkoutTime))
            default:
                confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("title_forgot_in"),
                                                       value: requestModel.checkinTime))
                break
            }
        }
    }

    func appendCompensationItem() {
        if leaveType?.compensationKind == .require {
            confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                   header: LocalizationHelper.shared.localized("from"),
                                                   value: requestModel.compensationAttributes.compensationFrom))
            confirmItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                   header: LocalizationHelper.shared.localized("to"),
                                                   value: requestModel.compensationAttributes.compensationTo))
            confirmItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                                   header: LocalizationHelper.shared.localized("reason"),
                                                   value: requestModel.reason))
        }
    }

    @IBAction func submitBtnClick(_ sender: Any) {
        submitRequestLeave(requestModel: requestModel)
    }
}

extension ConfirmCreateRequestLeaveViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateLeaveCell", for: indexPath)
            as? ConfirmCreateRequestCell else {
                return UITableViewCell()
        }

        if indexPath.section == 0 {
            cell.updateCell(item: confirmItems[indexPath.row])
        } else {
            let startIndex = confirmItems.count - compensationRowNumber
            cell.updateCell(item: confirmItems[startIndex + indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leaveType?.compensationKind == .require {
            return section == 1 ? compensationRowNumber : confirmItems.count - compensationRowNumber
        } else {
            return confirmItems.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return leaveType?.compensationKind == .require ? 2 : 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return LocalizationHelper.shared.localized("compensation_time")

        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        header.backgroundView?.backgroundColor = UIColor.white
    }
}

extension ConfirmCreateRequestLeaveViewController: ConfirmCreateRequestLeaveViewControllerType {
    
    func didSubmitRequestSuccess() {
        navigationController?.popToRootViewController(animated: true)
    }
}
