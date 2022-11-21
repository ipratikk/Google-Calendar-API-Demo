//
//  CustomTimePicker.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 21/11/22.
//

import SwiftUI

struct CustomTimePicker: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    let months: [String] = Calendar.current.shortMonthSymbols

    var body: some View {

        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        selectedYear -= 1
                    }
                Text(String(selectedYear))
                    .font(.title2)
                    .fontWeight(.bold)
                    .transition(.move(edge: .trailing))
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        selectedYear += 1
                    }
                Spacer()
            }
            .padding()
            ScrollView(.horizontal) {
                ScrollViewReader { scroll in
                    HStack() {
                        ForEach((1...12), id: \.self) { item in
                            Text(months[item-1])
                                .fontWeight((item == selectedMonth) ? .bold : .regular)
                                .onTapGesture {
                                    self.selectedMonth = item
                                }
                                .id(item)
                                .padding([.top, .bottom], 2)
                                .padding([.leading, .trailing], 15)
                                .background((item == selectedMonth) ? .blue : .secondary)
                                .cornerRadius(25)
                        }
                    }
                    .task {
                        scroll.scrollTo(selectedMonth, anchor: .center)
                    }
                }
            }
            .padding()
            Divider()
        }
        .onAppear() {
            selectedYear = Date.now.get(.year)
            selectedMonth = Date.now.get(.month)
        }
    }
}
