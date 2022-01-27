//
//  ContentView.swift
//  Search Images
//
//  Created by Дмитрий Балантаев on 27.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Home: View {
    @State var expand = false
    @State var search = ""
    @ObservedObject var RandomImages = getData()
    @State var page = 1
    @State var isSearching = false
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        VStack(spacing: 0) {
            HStack {
                if !self.expand {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Поиск картиночек")
                            .font(.title)
                            .fontWeight(.bold)
                    }.foregroundColor(.black)
                }
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation {
                            self.expand = true
                        }
                    }
                
                if self.expand {
                    TextField("Что ищем?", text: self.$search)
                
                    if self.search != "" {
                        Button(action: {
                            self.RandomImages.Images.removeAll()
                            self.isSearching = true
                            self.page = 1
                            self.SearchData()
                        }) {
                            Text("Искать")
                                .fontWeight(.light)
                                .foregroundColor(.black)
                        }
                    }
                    Button(action: {
                        withAnimation {
                            self.expand = false
                        }
                        self.search = ""
                        
                        if self.isSearching {
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                            self.RandomImages.updateData()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black )
                    }
                    .padding(.leading,10)
                }
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
      
            if self.RandomImages.Images.isEmpty {
                Spacer()
                if self.RandomImages.noresults {
                    Text("Ничего не найдено")
                } else {
                    indicator()
                }
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(self.RandomImages.Images,id: \.self) { i in
                            HStack(spacing: 20) {
                                ForEach(i) { j in
                                    AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 200)
                                        .cornerRadius(15)
                                        .contextMenu {
                                            Button(action: {
                                                SDWebImageDownloader()
                                                    .downloadImage(with: URL(string: j.urls["full"]!)) {(image, _, _, _)
                                                        in
                                                        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                                    }
                                            }) {
                                                HStack {
                                                    Text("Сохранить")
                                                    Spacer()
                                                    Image(systemName: "square.and.arrow.down.fill")
                                                }
                                                .foregroundColor(.black)
                                                
//                                                HStack {
//                                                    Button {
//                                                                presentationMode.wrappedValue.dismiss()
//                                                            } label: {
//                                                                Label("Close", systemImage: "xmark.circle")
//                                                            }
//                                                }
                                                
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
        
    }
    func SearchData() {
        
        let key = "AfMzLNn7FN9YVCyvXNGGZ3EQnKETm0B-yB6cN31Umc8"
        let query = self.search.replacingOccurrences(of: "", with: "%20")
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        self.RandomImages.SearchData(url: url)
    }
}
