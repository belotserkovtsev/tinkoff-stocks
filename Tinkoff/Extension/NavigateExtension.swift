//
//  NavigateExtension.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import SwiftUI

extension View {
	
	/// Navigate to a new view.
	/// - Parameters:
	///   - view: View to navigate to.
	///   - binding: Only navigates when this condition is `true`.
	func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>, fromName: String?, toName: String?) -> some View {
		NavigationView {
			ZStack {
				self
					.navigationBarTitle(fromName ?? "")
					.navigationBarHidden(true)
				
				NavigationLink(
					destination: view
						.navigationBarTitle(toName ?? "", displayMode: .inline)
						.navigationBarHidden(toName == nil),
					isActive: binding
				) {
					EmptyView()
				}
			}
		}
	}
}
