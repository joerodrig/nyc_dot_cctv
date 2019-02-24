RSpec.describe NycDotCctv do
  it "has a version number" do
    expect(NycDotCctv::VERSION).not_to be nil
  end

  describe "#request_image" do
    before do
      MockedTime = Struct.new(:utc)
      allow(Time).to receive(:now).and_return(MockedTime.new(fake_time))
    end

    let(:fake_time) { 123 }

    context "when an invalid cctv_id is provided" do
      subject(:result) { described_class.request_image("") }

      it "returns a hash containing an error" do
        expect(result).to eq(
          errors: ["An invalid CCTV ID was provided"],
          requested_at: fake_time
        )
      end
    end

    context "when a valid cctv_id is provided" do
      it "sends a GET request" do
        MockedHttpGetResponse = Struct.new(:body, :code)
        expect(Net::HTTP).to receive(:get_response)
          .and_return(MockedHttpGetResponse.new({body: "", code: "200"}))
        described_class.request_image("1")
      end
    end
  end

  describe "generate_uri" do
    before do
      allow(Random).to receive(:rand).and_return(mocked_random_num)
    end

    let(:mocked_random_num) { 0.12345 }
    let(:cctv_id) { "1" }

    context "when custom options aren't provided" do
      subject(:result) { described_class.generate_uri(cctv_id) }

      it "generates a URI with the default options" do
        expect(result).to eq(URI(
          "http://207.251.86.238" \
          "/cctv#{cctv_id}.jpg" \
          "?rand=#{mocked_random_num}:80"
        ))
      end
    end

    context "when a custom host is provided" do
      subject(:result) { described_class.generate_uri(
        cctv_id,
        custom_opts: {host: custom_host})
      }

      let(:custom_host) { "google.com" }

      it "generates a URI with the custom host and sets others to defaults" do

        expect(result).to eq(URI(
          "http://#{custom_host}" \
          "/cctv#{cctv_id}.jpg" \
          "?rand=#{mocked_random_num}:80"
        ))
      end
    end

    context "when a custom image type is provided" do
      subject(:result) { described_class.generate_uri(
        cctv_id,
        custom_opts: {img_type: custom_image_type})
      }

      let(:custom_image_type) { "tiff" }

      it "generates a URI with the custom host and sets others to defaults" do

        expect(result).to eq(URI(
          "http://207.251.86.238" \
          "/cctv#{cctv_id}.#{custom_image_type}" \
          "?rand=#{mocked_random_num}:80"
        ))
      end
    end

    context "when a custom port is provided" do
      subject(:result) { described_class.generate_uri(
        cctv_id,
        custom_opts: {port: custom_port})
      }

      let(:custom_port) { "443" }

      it "generates a URI with the custom host and sets others to defaults" do

        expect(result).to eq(URI(
          "http://207.251.86.238" \
          "/cctv#{cctv_id}.jpg" \
          "?rand=#{mocked_random_num}:#{custom_port}"
        ))
      end
    end
  end

  describe "#cctv_host" do
    let(:default_host) { described_class::DEFAULT_CAMERA_IP }

    context "when a valid host isn't specified" do
      subject(:result) { described_class.cctv_host("") }

      it { is_expected.to eq(default_host) }
    end

    context "when a valid host is specified" do
      subject(:result) { described_class.cctv_host(specified_host) }
      let(:specified_host) { "google.com" }

      it { is_expected.to eq(specified_host) }
    end
  end

  describe "#invalid_host?" do
    context "when the 'host' param is not a string" do
      it "returns false" do
        expect(described_class.invalid_host?({test: "123"})).to eq(true)
        expect(described_class.invalid_host?(123)).to eq(true)
        expect(described_class.invalid_host?(["123"])).to eq(true)
      end
    end

    context "when the 'host' param is a string" do
      context "when it is empty" do
        subject(:result) { described_class.invalid_host?("") }

        it { is_expected.to eq(true) }
      end

      context "when it is not empty" do
        subject(:result) { described_class.invalid_host?("google.com") }

        it { is_expected.to eq(false) }
      end
    end
  end
end
