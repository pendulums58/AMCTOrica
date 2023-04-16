--라디언트 효과
EVENT_AMASS=101270000


--자신이 공개되어 있을 경우 컨디션
function cyan.selfpubcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end