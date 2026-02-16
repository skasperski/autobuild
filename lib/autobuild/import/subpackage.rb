module Autobuild
    class Subpackage < Importer
        def initialize(source, options = {})
            @source = source
            parent_name = options[:parent]
            raise "Subpackage must provide a parent package." unless parent_name
            @parent = Autoproj.workspace.manifest.package_definition_by_name(parent_name)
            raise "Parent package #{parent_name} does not exist." unless @parent
            raise "Parent package #{parent_name} has no importer." unless @parent.autobuild.importer

            super(options.merge(repository_id: source))
        end

        def update(_package, options = Hash.new) # :nodoc:
            @parent.autobuild.importer.update(@parent, options)
        end

        def checkout(_package, options = Hash.new) # :nodoc:
            @parent.autobuild.importer.checkout(@parent.autobuild, options)
        end
    end

    def self.subpackage(source, options = {})
        Subpackage.new(source, options)
    end
end
