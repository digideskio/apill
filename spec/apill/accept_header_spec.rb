require 'rspectacular'
require 'apill/accept_header'

module    Apill
describe  AcceptHeader do
  it 'can validate an accept header with all the pieces of information' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=1.0.0')

    expect(header).to be_valid
  end

  it 'does not validate an accept header without passing an application' do
    header = AcceptHeader.new(application:  '',
                              header:       'application/vnd.matrix+zion;version=1.0.0')

    expect(header).not_to be_valid
  end

  it 'does not validate an accept header if it is not passed in' do
    header = AcceptHeader.new(application:  '',
                              header:       '')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  '',
                              header:       nil)

    expect(header).not_to be_valid
  end

  it 'does not validate an accept header without an application in the header' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.+zion;version=1.0.0')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/+zion;version=1.0.0')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/matrix+zion;version=1.0.0')

    expect(header).not_to be_valid
  end

  it 'does not validate an accept header with an invalid version' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=10..0')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=neo')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=')

    expect(header).not_to be_valid

    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;10.0')

    expect(header).not_to be_valid
  end

  it 'does validate an accept header even with a missing content type' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix;version=10.0')

    expect(header).to be_valid
  end

  it 'does validate an accept header with only the minimal information' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix')

    expect(header).to be_valid
  end

  it 'does validate an accept header with only a content type but no version' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion')

    expect(header).to be_valid
  end

  it 'can extract version information from an accept header' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=10.0.0beta1')

    expect(header.version).to eql '10.0.0beta1'
  end

  it 'can extract the content type from an accept header' do
    header = AcceptHeader.new(application:  'matrix',
                              header:       'application/vnd.matrix+zion;version=10.0.0beta1')

    expect(header.content_type).to eql 'zion'
  end
end
end
