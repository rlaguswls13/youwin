
@Getter
@Setter
@ToString(exclude = "password")
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {
    private String memberId;
    private String memberPassword;
    private String nickname;
    private String memberEmail;
    private String memberPhone;

}