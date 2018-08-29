platform :ios, '10.3'
inhibit_all_warnings!
use_frameworks!


def shared_pods
    pod 'Alamofire'
    pod 'ORStackView'
    pod 'SwiftyJSON'
    pod 'ObjectMapper'
    pod 'ReactiveCocoa', '~> 7.0'
    pod 'KeychainAccess'
    pod 'PromiseKit'
    pod 'AlamofireObjectMapper'
    pod 'Bolts-Swift', :git => 'https://github.com/BoltsFramework/Bolts-Swift.git'
    pod 'HandyJSON', '4.0.0-beta.1'
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift' # includes the Default subspec, with support for NSURLSession & JSON, and the Swiftier API wrappers
    pod 'AlamofireObjectMapper'
    pod 'CodableAlamofire'
    pod 'lottie-ios'
    pod 'Skeleton'
    pod 'SkeletonView'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase'
    pod 'LetterAvatarKit'
end

def testing_pods
    pod 'Quick'
    pod 'Nimble'
#    pod 'Mockingjay', :git => 'https://github.com/metaltoad/Mockingjay.git', :branch => 'mt-swift4'
# pod 'TRON'
#  pod 'OPERA'
end

target 'DC Metro' do
    shared_pods
    # prevents linking OHHTTPStubs to the test target (your App) so that it only loads once.
end

target 'DC MetroTests' do
    shared_pods
    testing_pods
end

target 'DC MetroUITests' do
    
end

#    pod 'SQLite.swift'
#  pod 'Moya-ObjectMapper'
#  pod 'swiftydb'
#   pod 'Moya'
#   pod 'Malibu'
#    pod 'BrightFutures'
#    pod 'LockSmith'
#    pod 'Sync'
#    pod 'SweetRouter'
#    CoreValue/CoreStore
#    pod 'PromiseKit/Alamofire', '~> 4.0'
#   SwiftyJSONModel
#   AlamofireObjectMapper
#pod 'Fallback', '~> 0.2'



