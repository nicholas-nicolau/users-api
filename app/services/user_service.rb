class UserService
  attr_reader :errors, :record

  def initialize(parameters={})
    @parameters = parameters

    @errors = []
    @record = nil
    @success = false
  end

  def success?
    @success
  end

  def create
    record = User.new(@parameters)

    save_record(record)
  end

  def update(id)
    record = User.find(id)

    record.assign_attributes(@parameters)

    save_record(record)
  end

  def destroy(id)
    record = User.find(id)

    record.destroy!

    @success = true
  end

  private

  def save_record(record)
    if record.save
      @success = true
      @record = record.reload
    else
      @success = false
      @errors = record.errors.full_messages
    end
  end
end