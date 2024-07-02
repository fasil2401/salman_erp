
import 'dart:convert';

GetUserEmployeeModel getUserEmployeeModelFromJson(String str) => GetUserEmployeeModel.fromJson(json.decode(str));

String getUserEmployeeModelToJson(GetUserEmployeeModel data) => json.encode(data.toJson());

class GetUserEmployeeModel {
    GetUserEmployeeModel({
       required this.res,
       required this.model,
    });

    int res;
    List<UserEmployeeModel> model;

    factory GetUserEmployeeModel.fromJson(Map<String, dynamic> json) => GetUserEmployeeModel(
        res: json["res"],
        model: List<UserEmployeeModel>.from(json["model"].map((x) => UserEmployeeModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
    };
}

class UserEmployeeModel {
    UserEmployeeModel({
        this.employeeId,
        this.lastName,
        this.firstName,
        this.middleName,
        this.birthDate,
        this.nickName,
        this.joiningDate,
        this.groupId,
        this.terminationDate,
        this.terminationId,
        this.isTerminated,
        this.cancellationDate,
        this.isCancelled,
        this.gradeId,
        this.dayOff,
        this.onVacation,
        this.birthPlace,
        this.sponsorId,
        this.nationalityId,
        this.probation,
        this.confirmationDate,
        this.religionId,
        this.bloodGroup,
        this.qualification,
        this.contractType,
        this.annualLeaveDate,
        this.resumedDate,
        this.notes,
        this.locationId,
        this.divisionId,
        this.companyDivisionId,
        this.defaultCostCenterId,
        this.departmentId,
        this.positionId,
        this.reportToId,
        this.payPeriod,
        this.gender,
        this.maritalStatus,
        this.spouseName,
        this.accountId,
        this.bankId,
        this.nationalId,
        this.uid,
        this.visaNumber,
        this.passPortNumber,
        this.status,
        this.labourId,
        this.empAnalysisId,
        this.iban,
        this.lastRevisedSalaryDate,
        this.primaryAddressId,
        this.calendarId,
        this.userDefined1,
        this.userDefined2,
        this.userDefined3,
        this.userDefined4,
        this.previousRevisedSalaryDate,
        this.medicalInsuranceProviderId,
        this.medicalInsuranceCategoryId,
        this.medicalInsuranceNumber,
        this.medicalInsValidFrom,
        this.medicalInsValidTo,
        this.numberOfDependants,
        this.recruitmentChannelId,
        this.visaDesignationId,
        this.medicalInsuranceAmount,
        this.legalPositionId,
        this.appointmentSysDocId,
        this.appointmentVoucherId,
        this.photo,
        this.rehireDate,
        this.isEosSettled,
        this.eosRuleId,
        this.overtimeId,
        this.paymentMethodId,
        this.accountNumber,
        this.lastPayDate,
        this.destinationId,
        this.numberOfTickets,
        this.ticketAmount,
        this.ticketPeriod,
        this.ticketRemarks,
        this.currencyId,
        this.salaryRemarks,
        this.basicSalary,
        this.balance,
        this.pdcAmount,
        this.appriasalPoints,
        this.approvalStatus,
        this.verificationStatus,
        this.dateCreated,
        this.dateUpdated,
        this.createdBy,
        this.updatedBy,
        this.hasPhoto,
        this.servicePeriodMonth,
        this.stlbank,
        this.stldate,
    });

    String? employeeId;
    String? lastName;
    String? firstName;
    String? middleName;
    String? birthDate;
    String? nickName;
    String? joiningDate;
    String? groupId;
    dynamic terminationDate;
    dynamic terminationId;
    dynamic isTerminated;
    dynamic cancellationDate;
    dynamic isCancelled;
    dynamic gradeId;
    dynamic dayOff;
    dynamic onVacation;
    String? birthPlace;
    String? sponsorId;
    String? nationalityId;
    dynamic probation;
    dynamic confirmationDate;
    String? religionId;
    String? bloodGroup;
    String? qualification;
    String? contractType;
    dynamic annualLeaveDate;
    dynamic resumedDate;
    String? notes;
    String? locationId;
    String? divisionId;
    String? companyDivisionId;
    dynamic defaultCostCenterId;
    String? departmentId;
    String? positionId;
    String? reportToId;
    dynamic payPeriod;
    String? gender;
    dynamic maritalStatus;
    String? spouseName;
    String? accountId;
    String? bankId;
    String? nationalId;
    String? uid;
    String? visaNumber;
    dynamic passPortNumber;
    dynamic status;
    String? labourId;
    dynamic empAnalysisId;
    String? iban;
    String? lastRevisedSalaryDate;
    String? primaryAddressId;
    dynamic calendarId;
    dynamic userDefined1;
    dynamic userDefined2;
    dynamic userDefined3;
    dynamic userDefined4;
    dynamic previousRevisedSalaryDate;
    dynamic medicalInsuranceProviderId;
    dynamic medicalInsuranceCategoryId;
    String? medicalInsuranceNumber;
    String? medicalInsValidFrom;
    String? medicalInsValidTo;
    dynamic numberOfDependants;
    dynamic recruitmentChannelId;
    dynamic visaDesignationId;
    dynamic medicalInsuranceAmount;
    String? legalPositionId;
    dynamic appointmentSysDocId;
    dynamic appointmentVoucherId;
    String? photo;
    dynamic rehireDate;
    dynamic isEosSettled;
    dynamic eosRuleId;
    dynamic overtimeId;
    dynamic paymentMethodId;
    String? accountNumber;
    dynamic lastPayDate;
    dynamic destinationId;
    dynamic numberOfTickets;
   dynamic ticketAmount;
    dynamic ticketPeriod;
    String? ticketRemarks;
    dynamic currencyId;
    String? salaryRemarks;
    dynamic basicSalary;
    dynamic balance;
    dynamic pdcAmount;
    dynamic appriasalPoints;
    dynamic approvalStatus;
    dynamic verificationStatus;
    String? dateCreated;
    String? dateUpdated;
    String? createdBy;
    String? updatedBy;
    String? hasPhoto;
    String? servicePeriodMonth;
    dynamic stlbank;
    dynamic stldate;

    factory UserEmployeeModel.fromJson(Map<String, dynamic> json) => UserEmployeeModel(
        employeeId: json["EmployeeID"],
        lastName: json["LastName"],
        firstName: json["FirstName"],
        middleName: json["MiddleName"],
        birthDate: json["BirthDate"],
        nickName: json["NickName"],
        joiningDate: json["JoiningDate"],
        groupId: json["GroupID"],
        terminationDate: json["TerminationDate"],
        terminationId: json["TerminationID"],
        isTerminated: json["IsTerminated"],
        cancellationDate: json["CancellationDate"],
        isCancelled: json["IsCancelled"],
        gradeId: json["GradeID"],
        dayOff: json["DayOff"],
        onVacation: json["OnVacation"],
        birthPlace: json["BirthPlace"],
        sponsorId: json["SponsorID"],
        nationalityId: json["NationalityID"],
        probation: json["Probation"],
        confirmationDate: json["ConfirmationDate"],
        religionId: json["ReligionID"],
        bloodGroup: json["BloodGroup"],
        qualification: json["Qualification"],
        contractType: json["ContractType"],
        annualLeaveDate: json["AnnualLeaveDate"],
        resumedDate: json["ResumedDate"],
        notes: json["Notes"],
        locationId: json["LocationID"],
        divisionId: json["DivisionID"],
        companyDivisionId: json["CompanyDivisionID"],
        defaultCostCenterId: json["DefaultCostCenterID"],
        departmentId: json["DepartmentID"],
        positionId: json["PositionID"],
        reportToId: json["ReportToID"],
        payPeriod: json["PayPeriod"],
        gender: json["Gender"],
        maritalStatus: json["MaritalStatus"],
        spouseName: json["SpouseName"],
        accountId: json["AccountID"],
        bankId: json["BankID"],
        nationalId: json["NationalID"],
        uid: json["UID"],
        visaNumber: json["VisaNumber"],
        passPortNumber: json["PassPortNumber"],
        status: json["Status"],
        labourId: json["LabourID"],
        empAnalysisId: json["EmpAnalysisID"],
        iban: json["IBAN"],
        lastRevisedSalaryDate: json["LastRevisedSalaryDate"],
        primaryAddressId: json["PrimaryAddressID"],
        calendarId: json["CalendarID"],
        userDefined1: json["UserDefined1"],
        userDefined2: json["UserDefined2"],
        userDefined3: json["UserDefined3"],
        userDefined4: json["UserDefined4"],
        previousRevisedSalaryDate: json["PreviousRevisedSalaryDate"],
        medicalInsuranceProviderId: json["MedicalInsuranceProviderID"],
        medicalInsuranceCategoryId: json["MedicalInsuranceCategoryID"],
        medicalInsuranceNumber: json["MedicalInsuranceNumber"],
        medicalInsValidFrom: json["MedicalInsValidFrom"],
        medicalInsValidTo: json["MedicalInsValidTo"],
        numberOfDependants: json["NumberOfDependants"],
        recruitmentChannelId: json["RecruitmentChannelID"],
        visaDesignationId: json["VisaDesignationID"],
        medicalInsuranceAmount: json["MedicalInsuranceAmount"],
        legalPositionId: json["LegalPositionID"],
        appointmentSysDocId: json["AppointmentSysDocID"],
        appointmentVoucherId: json["AppointmentVoucherID"],
        photo: json["Photo"],
        rehireDate: json["RehireDate"],
        isEosSettled: json["IsEOSSettled"],
        eosRuleId: json["EOSRuleID"],
        overtimeId: json["OvertimeID"],
        paymentMethodId: json["PaymentMethodID"],
        accountNumber: json["AccountNumber"],
        lastPayDate: json["LastPayDate"],
        destinationId: json["DestinationID"],
        numberOfTickets: json["NumberOfTickets"],
        ticketAmount: json["TicketAmount"],
        ticketPeriod: json["TicketPeriod"],
        ticketRemarks: json["TicketRemarks"],
        currencyId: json["CurrencyID"],
        salaryRemarks: json["SalaryRemarks"],
        basicSalary: json["BasicSalary"],
        balance: json["Balance"],
        pdcAmount: json["PDCAmount"],
        appriasalPoints: json["AppriasalPoints"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: json["DateCreated"],
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        hasPhoto: json["HasPhoto"],
        servicePeriodMonth: json["ServicePeriodMonth"],
        stlbank: json["STLBANK"],
        stldate: json["STLDATE"],
    );

    Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "LastName": lastName,
        "FirstName": firstName,
        "MiddleName": middleName,
        "BirthDate": birthDate,
        "NickName": nickName,
        "JoiningDate": joiningDate,
        "GroupID": groupId,
        "TerminationDate": terminationDate,
        "TerminationID": terminationId,
        "IsTerminated": isTerminated,
        "CancellationDate": cancellationDate,
        "IsCancelled": isCancelled,
        "GradeID": gradeId,
        "DayOff": dayOff,
        "OnVacation": onVacation,
        "BirthPlace": birthPlace,
        "SponsorID": sponsorId,
        "NationalityID": nationalityId,
        "Probation": probation,
        "ConfirmationDate": confirmationDate,
        "ReligionID": religionId,
        "BloodGroup": bloodGroup,
        "Qualification": qualification,
        "ContractType": contractType,
        "AnnualLeaveDate": annualLeaveDate,
        "ResumedDate": resumedDate,
        "Notes": notes,
        "LocationID": locationId,
        "DivisionID": divisionId,
        "CompanyDivisionID": companyDivisionId,
        "DefaultCostCenterID": defaultCostCenterId,
        "DepartmentID": departmentId,
        "PositionID": positionId,
        "ReportToID": reportToId,
        "PayPeriod": payPeriod,
        "Gender": gender,
        "MaritalStatus": maritalStatus,
        "SpouseName": spouseName,
        "AccountID": accountId,
        "BankID": bankId,
        "NationalID": nationalId,
        "UID": uid,
        "VisaNumber": visaNumber,
        "PassPortNumber": passPortNumber,
        "Status": status,
        "LabourID": labourId,
        "EmpAnalysisID": empAnalysisId,
        "IBAN": iban,
        "LastRevisedSalaryDate": lastRevisedSalaryDate,
        "PrimaryAddressID": primaryAddressId,
        "CalendarID": calendarId,
        "UserDefined1": userDefined1,
        "UserDefined2": userDefined2,
        "UserDefined3": userDefined3,
        "UserDefined4": userDefined4,
        "PreviousRevisedSalaryDate": previousRevisedSalaryDate,
        "MedicalInsuranceProviderID": medicalInsuranceProviderId,
        "MedicalInsuranceCategoryID": medicalInsuranceCategoryId,
        "MedicalInsuranceNumber": medicalInsuranceNumber,
        "MedicalInsValidFrom": medicalInsValidFrom,
        "MedicalInsValidTo": medicalInsValidTo,
        "NumberOfDependants": numberOfDependants,
        "RecruitmentChannelID": recruitmentChannelId,
        "VisaDesignationID": visaDesignationId,
        "MedicalInsuranceAmount": medicalInsuranceAmount,
        "LegalPositionID": legalPositionId,
        "AppointmentSysDocID": appointmentSysDocId,
        "AppointmentVoucherID": appointmentVoucherId,
        "Photo": photo,
        "RehireDate": rehireDate,
        "IsEOSSettled": isEosSettled,
        "EOSRuleID": eosRuleId,
        "OvertimeID": overtimeId,
        "PaymentMethodID": paymentMethodId,
        "AccountNumber": accountNumber,
        "LastPayDate": lastPayDate,
        "DestinationID": destinationId,
        "NumberOfTickets": numberOfTickets,
        "TicketAmount": ticketAmount,
        "TicketPeriod": ticketPeriod,
        "TicketRemarks": ticketRemarks,
        "CurrencyID": currencyId,
        "SalaryRemarks": salaryRemarks,
        "BasicSalary": basicSalary,
        "Balance": balance,
        "PDCAmount": pdcAmount,
        "AppriasalPoints": appriasalPoints,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated,
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "HasPhoto": hasPhoto,
        "ServicePeriodMonth": servicePeriodMonth,
        "STLBANK": stlbank,
        "STLDATE": stldate,
    };
}
