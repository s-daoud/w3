class CorgiPerk

  def initialize(perk_id, shopping_list)
    @id = perk_id
    @shopping_list = shopping_list
  end

  # def bone
  #   info = @shopping_list.get_bone_info(@id)
  #   happiness = @shopping_list.get_bone_happiness(@id)
  #   result = "Bone: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end
  #
  # def kibble
  #   info = @shopping_list.get_kibble_info(@id)
  #   happiness = @shopping_list.get_kibble_happiness(@id)
  #   result = "Kibble: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end
  #
  # def silly_outfit
  #   info = @shopping_list.get_silly_outfit_info(@id)
  #   happiness = @shopping_list.get_silly_outfit_happiness(@id)
  #   result = "Silly Outfit: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end

  def self.define_perk(perk)
    define_method(perk) do
      info = @shopping_list.send("get_#{perk}_info", @id)
      happiness = @shopping_list.send("get_#{perk}_happiness", @id)
      result = "#{perk.capitalize.split("_").join(" ")}: #{info}: #{happiness}"
      happiness > 30 ? "* #{result}" : result
    end
  end

  def method_missing(perk, *args)
    info = @shopping_list.send("get_#{perk}_info", args[0])
    happiness = @shopping_list.send("get_#{perk}_happiness", args[0])
    result = "#{perk.capitalize.split("_").join(" ")}: #{info}: #{happiness}"
    happiness > 30 ? "* #{result}" : result
  end
end
