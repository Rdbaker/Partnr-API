describe "Partnr.Models.MessageModel", () ->
  it "exists", () ->
    expect(Partnr.Models.MessageModel).to.exist

  describe "#save()", () ->
    it "exists", () ->
      m = new Partnr.Models.MessageModel()
      expect(m.save).to.exist

  describe "#validParams()", () ->
    it "exists", () ->
      m = new Partnr.Models.MessageModel()
      expect(m.validParams).to.exist

    it "passes for a good model", () ->
      good = new Partnr.Models.MessageModel {"conv_id": "1", "message": "some string"}

      expect(good.validParams()).to.be true
###
    it "fails for a bad model", () ->
      bad = Partnr.Models.MessageModel({})

      expect(bad.validParams()).to.be(false)
###
