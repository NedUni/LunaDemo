//
//  RegisterView.swift
//  Luna
//
//  Created by Ned O'Rourke on 8/1/22.
//
import SwiftUI
import GameController
import FirebaseAuth
//import FirebaseStorage
import Firebase

struct RegisterView: View {
    
    @EnvironmentObject private var vm : SessionServiceImpl
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State private var date = Date()
    
    
    @State var email : String = ""
    @State var password : String = ""
    @State var confirmedPassword : String = ""
    @State var firstName : String = ""
    @State var lastName : String = ""
    @State var dob : Date = Date.now
    @State var dobString : String = ""
    @State var error : String = ""

    let dateFormatter = DateFormatter()
    
        
    var body: some View {
        
        
        NavigationView {
            
            VStack(spacing: 16) {
                
                VStack {
                    
                    Button {
                       shouldShowImagePicker
                            .toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:128, height:128)
                                    .cornerRadius(64)
                                    .padding()
                                    
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:128, height:128)
                                    .cornerRadius(64)
                                    .padding()

                                    
                            }
                            Text("Select Profile Picture")
                                .foregroundColor(Color.secondary)
                        }
                    }
                    .padding(.bottom)
                    
                    TextInputView(text: $email,
                                  placeholder: "Email",
                                  keyboardType: .emailAddress,
                                  sfSymbol: "envelope")
                        .autocapitalization(.none)

                    PasswordInputView(password: $password,
                                      placeholder: "Password",
                                      sfSymbol: "lock")
                    
                    PasswordInputView(password: $confirmedPassword,
                                      placeholder: "Confirm Password",
                                      sfSymbol: "lock")
                    
                    Divider()
                    
                    TextInputView(text: $firstName,
                                  placeholder: "First Name",
                                  keyboardType: .default,
                                  sfSymbol: nil)
                        .autocapitalization(.words)
                    
                    TextInputView(text: $lastName,
                                  placeholder: "Last Name",
                                  keyboardType: .default,
                                  sfSymbol: nil)
                        .autocapitalization(.words)
                    

                   
                    
                    HStack {
                        DatePicker("Date of Birth", selection: $dob, displayedComponents: [.date])
                        .frame(maxWidth: .infinity,
                                minHeight: 44)
                        .padding(.trailing)
                        .padding(.leading)

                        .foregroundColor(Color.gray.opacity(0.5))
                        .background (
                            ZStack(alignment: .leading) {

                                RoundedRectangle(cornerRadius: 44,
                                                 style: .continuous)
                                    .stroke(Color.gray.opacity(0.5))
                            }
                        )


                    }
                    
                    HStack {
                        Text(error)
                            .foregroundColor(.red).bold()
                    }
                    .frame(maxHeight: 60)
                          

                }
                
                
                
                ButtonView(title: "Sign Up") {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    dobString = dateFormatter.string(from: dob)
                    
                    var a = false
                    var b = false
                    var c = false
                    
                    if password == confirmedPassword {
                        a = true
                    }
                    
                    else {
                        error = "Passwords don't match."
                        return
                    }
                    
                    if (password == "" || confirmedPassword == "" || firstName == "" || lastName == "" || email == "") {
                        error = "Please fill out all fields."
                        return
                    }
                    
                    else {
                        b = true
                    }
                    
                    if password.count < 6 {
                        error = "Password must at least 6 characters."
                        return
                    } else {
                        c = true
                        
                    }
                    
                    let barrier = Calendar.current.date(byAdding: .year, value: -18, to: Date.now)
                    
                    if dob > barrier! {
                        error = "You must be over 18 to use Luna"
                        return
                    } else {
                    
                        if a == true && b == true && c == true {
                            error = ""
                            
                            vm.register(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines), firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines), lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines), dob: dobString, image: (self.image ?? UIImage(named: "stockProfilePicture"))!, completion: {
                                if vm.registerError != "" {
                                    error = vm.registerError
                                }
                            })


                            
                        }
                    }
                    

                }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Register")
            .ignoresSafeArea(.keyboard)
            .applyClose()
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
               ImagePicker(image: $image)
        }
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

