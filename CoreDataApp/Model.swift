import Foundation

func getAlbums(post: Post) -> [Album] {
    guard let user = post.user else {
        return []
    }
    guard let albumSet = user.albums else {
        return []
    }
    return albumSet.flatMap { setItem -> Album? in
        guard let album = setItem as? Album else {
            return nil
        }
        return album
    }
}

func getPhotos(album: Album) -> [Photo] {
    guard let photoSet = album.photos else {
        return []
    }
    return photoSet.flatMap { setItem -> Photo? in
        guard let photo = setItem as? Photo else {
            return nil
        }
        return photo
    }
}
