//
//  Container.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

struct Container {
    func makeFilesystemNetworkDataSource() -> FilesystemNetworkDataSource {
        DefaultFilesystemNetworkDataSource(sheetId: Configuration.requiredString(byKey: "API_SHEET_ID"),
                                           service: makeGSheetService())
    }
    
    func makeFilesystemRepository() -> FilesystemRepository {
        DefaultFilesystemRepository(networkDataSource: makeFilesystemNetworkDataSource())
    }
    
    func makeGetFilesystemItemsUseCase() -> GetFilesystemItemsUseCase {
        DefaultGetFilesystemItemsUseCase(repository: makeFilesystemRepository())
    }
    
    func makeSaveFilesystemItemUseCase() -> SaveFilesystemItemUseCase {
        DefaultSaveFilesystemItemUseCase(repository: makeFilesystemRepository())
    }
    
    func makeDeleteFilesystemItemUseCase() -> DeleteFilesystemItemUseCase {
        DefaultDeleteFilesystemItemUseCase(repository: makeFilesystemRepository())
    }
    
    func makeFilesystemListViewModel(forParent parent: FilesystemItem?) -> FilesystemListViewModel {
        FilesystemListViewModel(parent: parent,
                                getFilesystemItemsUseCase: makeGetFilesystemItemsUseCase(),
                                saveFilesystemItemUseCase: makeSaveFilesystemItemUseCase(),
                                deleteFilesystemItemUseCase: makeDeleteFilesystemItemUseCase())
    }
    
    func makeGSheetService() -> GSheetsService {
        return GSheetsService(configuration: .init(apiKey: Configuration.requiredString(byKey: "API_KEY")))
    }
}