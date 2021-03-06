module DonationsHelper
  def create_donation_from_ext(resource, ext_donation)
    @project = Project.find ext_donation.project_id
    if !@project.item_based
      resource.donations.create(
        status: "SUCCESSFUL", amount: ext_donation.amount,
        note: "Converted from External Donation #{ext_donation.try(:email)} #{ext_donation.try(:phone)} #{ext_donation.try(:note)}",
        collection_method: ext_donation.collection_method,
        project_id: ext_donation.project_id,
        created_at: ext_donation.collection_time,
        project_reward_quantity: 1
      )
      ext_donation.update_attribute :status, "CONVERTED_TO_PLATFORM_DONATION"
      ext_donation.token.update_attribute :status, "USED"
    end
  end

  def auto_select_project_reward(project, donation_amount)
    @rewards = project.project_rewards
    @donation_amount = donation_amount.to_f
    @reward_amounts = @rewards.map(&:value)
    case @rewards.count
    when 1
      return @rewards[0].id
    else
      if @donation_amount < @reward_amounts.first
        return nil
      elsif @donation_amount >= @reward_amounts.last
        return @rewards.last.id
      else
        (0..@reward_amounts.count - 2).each do |index|
          return @rewards[index].id if (@donation_amount >= @reward_amounts[index] && @donation_amount < @reward_amounts[index+1])
        end
      end
    end
  end

  def sort_donations(donations, sort_by)
    case sort_by
    when "updated_at"
      return donations.group_by { |donation| donation.updated_at.to_date }
    when "collection_method"
      return donations.group_by { |donation| donation.collection_method }
    when "amount"
      return donations.order("amount DESC")
    end
  end

  def reward_popularity(project)
    @reward_popularity = Hash.new
    @project_rewards = project.project_rewards
    @project_rewards.each do |reward|
      @donations = project.donations.successful.where(project_reward_id: reward.id)
      @reward_popularity["#{reward.value}"] = @donations.count
    end
    return @reward_popularity
  end

  def funding_progress(project)
    @funding_progress = {}
    donations         = project.donations.successful
    ext_donations     = project.ext_donations
    start_date        = (project.start_date.beginning_of_day - 1.minute).to_date
    end_date          = (project.end_date.end_of_day + 1.minute).to_date
    start_date.upto(end_date) do |day|
      if day <= Date.today
        count = donations.where("created_at > ? AND created_at < ?", start_date, day + 1.day).sum(:amount)
        count += ext_donations.where("collection_time > ? AND collection_time < ?", start_date, day + 1.day).sum(:amount)
        # @funding_progress.push({:date => day.to_s, :sum => count})
        @funding_progress.merge!(day.to_s.to_sym => count)
      end
    end
    return @funding_progress
  end
end