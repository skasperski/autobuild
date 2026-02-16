module Autobuild
    class Subpackage < Importer
        def initialize(source, options = {})
            @source = source
            parent_name = options[:parent]
            if !parent_name
              raise "Subpackage must provide a parent package."
            end

            @parent = Autoproj.workspace.manifest.package_definition_by_name(parent_name)
            if !@parent
              raise "Parent package #{parent_name} does not exist."
            end

            if !@parent.autobuild.importer
              raise "Parent package #{parent_name} has no importer."
            end
            super(options.merge(repository_id: source))
        end

        def update(package, options = Hash.new) # :nodoc:
            @parent.autobuild.importer.update(@parent)
        end

        def checkout(package, _options = Hash.new) # :nodoc:
            @parent.autobuild.importer.checkout(@parent.autobuild)
        end
    end

    def self.subpackage(source, options = {})
        Subpackage.new(source, options)
    end
end
