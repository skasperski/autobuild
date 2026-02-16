module Autobuild
    class Subpackage < Importer
        def initialize(source, options = {})
            @source = source

            parent_name = options[:parent]
            unless parent_name
              raise "Subpackage must provide a parent package."
            end

            @parent = Autoproj.workspace.manifest.package_definition_by_name(parent_name)
            unless @parent
              raise "Parent package #{parent_name} does not exist."
            end

            super(options.merge(repository_id: source))
        end

        def update(_package, options = Hash.new) # :nodoc:
            false 
        end

        def checkout(package, options = Hash.new) # :nodoc:
            package.depends_on(@parent.autobuild)
        end
    end

    def self.subpackage(source, options = {})
        Subpackage.new(source, options)
    end
end
