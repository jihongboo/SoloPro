//
//  JobFormMode.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/13.
//

import Model

enum JobFormMode {
    case create
    case edit(Job)

    var title: String {
        switch self {
        case .create:
            "New Job"
        case .edit:
            "Edit Job"
        }
    }
}
