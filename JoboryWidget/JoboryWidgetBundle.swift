//
//  JoboryWidgetBundle.swift
//  JoboryWidget
//
//  Created by 纪洪波 on 2026/6/15.
//

import WidgetKit
import SwiftUI

@main
struct JoboryWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodayWidget()
        FocusedJobWidget()
//        JoboryWidgetControl()
//        JoboryWidgetLiveActivity()
    }
}
