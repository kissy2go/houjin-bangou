module HoujinBangou
  class ImmutableStruct < Struct
    private :[]=

    def initialize(*)
      super
      members.each { |member| instance_eval { undef :"#{member}=" } }
    end

    def inspect
      super.sub('struct', self.class.name)
    end
  end
end
