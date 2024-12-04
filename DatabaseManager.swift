////import FirebaseFirestore
////import FirebaseAuth
//
//class DatabaseManager {
//    static let shared = DatabaseManager()
//    private let db = Firestore.firestore()
//    
//    func createUserAccount(email: String, password: String, user: User, completion: @escaping (Bool) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                print("Error creating user: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            guard let uid = authResult?.user.uid else {
//                completion(false)
//                return
//            }
//            
//            self.db.collection("users").document(uid).setData([
//                "email": user.email,
//                "username": user.username,
//                "age": user.age,
//                "highSchool": user.highSchool,
//                "grade": user.grade
//            ]) { error in
//                if let error = error {
//                    print("Error saving user data: \(error.localizedDescription)")
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        }
//    }
//    
//    func loginUser(email: String, password: String, completion: @escaping (Bool, User?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                print("Login error: \(error.localizedDescription)")
//                completion(false, nil)
//                return
//            }
//            guard let uid = authResult?.user.uid else {
//                completion(false, nil)
//                return
//            }
//            
//            self.db.collection("users").document(uid).getDocument { snapshot, error in
//                if let error = error {
//                    print("Error fetching user: \(error.localizedDescription)")
//                    completion(false, nil)
//                    return
//                }
//                if let data = snapshot?.data() {
//                    let user = User(
//                        email: data["email"] as? String ?? "",
//                        username: data["username"] as? String ?? "",
//                        age: data["age"] as? Int ?? 0,
//                        highSchool: data["highSchool"] as? String ?? "",
//                        grade: data["grade"] as? String ?? ""
//                    )
//                    completion(true, user)
//                } else {
//                    completion(false, nil)
//                }
//            }
//        }
//    }
//}
//
