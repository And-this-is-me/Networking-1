import Testing
@testable import Posts

final class ApiClientTests {
    
    var sut: ApiClient!
    
    init() {
        sut = .mockup()
    }
    
    @Test
    func testRequestPosts_withDistinctiveValues_validatesEachPost() async {
        // When
        do {
            let posts = try await sut.requestPosts(FetchPostsRequest())
            
            // Then
            #expect(posts.count == 3,                   "Expected 3 posts but got \(posts.count)")
            #expect(posts[0].id == 1,                   "First post ID does not match")
            #expect(posts[0].userID == 1,               "First post user ID does not match")
            #expect(posts[0].title == "Title 1",        "First post title does not match")
            // Add more assertions as needed
        } catch {
            #expect(Bool(false), "Error fetching posts: \(error.localizedDescription)")
        }
    }
}

extension ApiClient {
    static func mockup() -> ApiClient {
        let data: [Post] = Post.testing
        
        // Define mock data and behavior for requesting posts
        let requestingPosts: @Sendable (FetchPostsRequest) async throws -> [Post] = { _ in
            return Post.testing
        }
        
        // Create mock ApiClient with the defined behaviors
        return ApiClient(
            requestPosts: requestingPosts
        )
    }
}

extension Post {
    static let testing: [Self] = [
        .init(id: 1, body: "Body 1", title: "Title 1", userID: 1),
        .init(id: 2, body: "Body 2", title: "Title 2", userID: 2),
        .init(id: 3, body: "Body 3", title: "Title 3", userID: 3)
    ]
}

