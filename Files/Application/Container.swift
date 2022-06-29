//
//  Container.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

@MainActor final class Container {
    var authroizationState: AuthroizationState? = nil
    
    func makeFilesystemNetworkDataSource() -> FilesystemNetworkDataSource {
        DefaultFilesystemNetworkDataSource(spreadsheetId: Configuration.requiredString(byKey: "API_SPREADSHEET_ID"),
                                           service: makeGSpreadsheetService())
    }
    
    func makeFilesystemRepository() -> FilesystemRepository {
        DefaultFilesystemRepository(networkDataSource: makeFilesystemNetworkDataSource())
    }
    
    func makeGetFilesystemItemsUseCase() -> GetFilesystemItemsUseCase {
        DefaultGetFilesystemItemsUseCase(repository: makeFilesystemRepository())
    }
    
    func makeGetSortedFilesystemItemsUseCase() -> GetSortedFilesystemItemsUseCase {
        DefaultGetSortedFilesystemItemsUseCase(getFilesystemItemsUseCase: makeGetFilesystemItemsUseCase())
    }
    
    func makeSaveFilesystemItemUseCase() -> SaveFilesystemItemUseCase {
        DefaultSaveFilesystemItemUseCase(repository: makeFilesystemRepository())
    }
    
    func makeDeleteFilesystemItemUseCase() -> DeleteFilesystemItemUseCase {
        DefaultDeleteFilesystemItemUseCase(repository: makeFilesystemRepository())
    }
    
    func makeFilesystemListViewModel(forParent parent: FilesystemItem?) -> FilesystemListViewModel {
        FilesystemListViewModel(parent: parent,
                                getFilesystemItemsUseCase: makeGetSortedFilesystemItemsUseCase(),
                                saveFilesystemItemUseCase: makeSaveFilesystemItemUseCase(),
                                deleteFilesystemItemUseCase: makeDeleteFilesystemItemUseCase())
    }
    
    func makeGSpreadsheetService() -> GSpreadsheetService {
        return GSpreadsheetService(configuration: .init(authorizationToken: authroizationState?.token))
    }
}
