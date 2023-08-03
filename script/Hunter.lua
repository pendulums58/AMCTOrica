
-- 수렵


--공통 효과 처리
function YiPi.HunterEffect(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) then
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if ft>-1 and Duel.CheckReleaseGroup(tp,YiPi.HunterCostFilter,1,false,nil,nil,ft,tp) then
				local op=Duel.SelectOption(tp,1152,1105)
				if op==0 then
					local g=Duel.SelectReleaseGroupCost(tp,YiPi.HunterCostFilter,1,1,false,nil,nil,ft,tp)
					if Duel.Release(g,REASON_EFFECT)~=0 then
						return Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
					end
				else
					return Duel.SendtoHand(c,nil,REASON_EFFECT)
				end			
			end
		else
			return Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function YiPi.HunterCostFilter(c,ft,tp)
	return c:IsFaceup() and c:IsSetCard(SETCARD_HUNTER)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function YiPi.HunterCheck(c)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return lv>=8
end
function YiPi.HunterSpChk(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end