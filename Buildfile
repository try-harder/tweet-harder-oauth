require 'buildr/as3'

custom_layout = Layout::Default.new
custom_layout[:source, :main, :as3] = "src"
custom_layout[:source, :main, :resources] = "resources"
custom_layout[:target, :main, :resources] = "bin"

# Flex SDK with FP11 just for fun
FLEX_SDK = FlexSDK.new('4.6.0.23201B')
FLEXUNIT_VERSION = '4.1.0-8'
FLEXUNIT_FLEX_SDK_VERSION = '4.1.0.16076'
FLEXUNIT_TYPE = :air

desc "Tweet Harder OAuth"
define 'tweet-harder-oauth', :layout => custom_layout  do
    project.version = "0.1.0"

    compile.using :airmxmlc,
        :flexsdk => FLEX_SDK,
        :main => _(:source, :main, :as3, "tryharder/tweetr/prototype/Main.as")

    compile.with [
        _(:lib, "as3crypto.swc"),
        _(:lib, "tweetrAIR.swc"),
    ]

    compile.options[:args] = [
        "-static-link-runtime-shared-libraries=true"
    ]

    compile.into 'bin'
end
