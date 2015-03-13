describe "Partnr.Models.MessageModel", () ->
  it "exists", () ->
    expect(Partnr.Models.MessageModel).to.exist

  beforeEach () ->
    @good = new Partnr.Models.MessageModel
      conv_id: "1",
      message: "some string"
    @bad = new Partnr.Models.MessageModel
      conv_id: undefined,
      message: undefined

  describe "#save()", () ->
    after () ->
      jQuery.ajax.restore()

    before () ->
      sinon.stub(jQuery, "ajax")

    it "throws an error on a bad model", () ->
      expect(@bad.save.bind(@bad))
        .to.throw(/Message does not have required attributes/)

    it "sends a PUT to the server on a good model", () ->
      @good.save()
      expect(jQuery.ajax.calledWithMatch
        url: '/messages/1',
        type: 'PUT'
        data:
          message: 'some string',
          conv_id: '1'
      )

  describe "#validate()", () ->
    it "passes for a good model", () ->
      expect(@good.validate()).to.be.true

    it "fails for a bad model", () ->
      expect(@bad.validate()).to.be.false
