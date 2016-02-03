require "middleman-core"
require "middleman-rouge/version"

::Middleman::Extensions.register(:rouge_syntax) do
  require "middleman-rouge/extension"
  ::Middleman::Rouge
end