require 'spec_helper'

describe HoujinBangou::ImmutableStruct do
  class ClassInheritedImmutableStruct < HoujinBangou::ImmutableStruct.new(:attr1, :attr2)
  end

  it 'has read accessors' do
    instance = ClassInheritedImmutableStruct.new('attr1', 'attr2')

    expect(instance.respond_to?(:attr1)).to be_truthy
    expect(instance.respond_to?(:attr2)).to be_truthy

    expect(instance.attr1).to eq 'attr1'
    expect(instance.attr2).to eq 'attr2'
  end

  it 'does not have write accessor' do
    instance = ClassInheritedImmutableStruct.new('attr1', 'attr2')

    expect(instance.respond_to?(:attr1=)).to be_falsey
    expect(instance.respond_to?(:attr2=)).to be_falsey
  end
end
