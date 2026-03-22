import SwiftUI
import UIKit

// MARK: - Wrapper

struct ImagePicker: UIViewControllerRepresentable {
    enum Source {
        case photoLibrary
        case camera
    }

    var source: Source = .photoLibrary
    var onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        switch source {
        case .photoLibrary:
            picker.sourceType = .photoLibrary
        case .camera:
            picker.sourceType = .camera
        }
        picker.allowsEditing = false   // set true if you want crop UI
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // no update needed for this controller
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // prefer edited image if allowsEditing was true
            let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            if let image { parent.onImagePicked(image) }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Example usage

struct PhotoCaptureView: View {
    @State private var showPicker = false
    @State private var useCamera = false
    @State private var image: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)
            }

            HStack {
                Button("Pick Photo") {
                    useCamera = false
                    showPicker = true
                }
                Button("Take Photo") {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        useCamera = true
                        showPicker = true
                    } else {
                        // handle no camera available if needed
                    }
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(source: useCamera ? .camera : .photoLibrary) { picked in
                image = picked
            }
        }
        .padding()
    }
}

