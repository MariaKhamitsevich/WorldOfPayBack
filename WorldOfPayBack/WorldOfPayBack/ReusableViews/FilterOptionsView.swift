//
//  FilterOptionsView.swift
//  WorldOfPayBack
//
//  Created by Maria on 10/12/2023.
//

import SwiftUI

struct FilterOptionsView<Option: FilterIterable>: View {
    @Binding private var selectedFilter: Option
    @Binding private var isPresented: Bool

    private let filterOptions: [Option]

    init(
        selectedFilter: Binding<Option>,
        isPresented: Binding<Bool>,
        filterOptions: [Option]
    ) {
        _selectedFilter = selectedFilter
        _isPresented = isPresented
        self.filterOptions = filterOptions
    }

    var body: some View {
        VStack {
            ForEach(filterOptions, id: \.filterName) { option in
                Button(action: {
                    selectedFilter = option
                    isPresented.toggle()
                }) {
                    Text(option.filterName)
                }
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal, 2)
    }
}
