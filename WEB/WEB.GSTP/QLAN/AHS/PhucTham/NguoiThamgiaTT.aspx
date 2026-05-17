<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiThamgiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.NguoiThamgiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="lstDataBC" Value="" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="hddTuCachTT_BiHai_ID" runat="server" Value="0" />

    <style>
        .rd_chon tr td {
            padding-right: 10px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="width: 90%; padding: 10px;">
                        <asp:RadioButtonList ID="rdbLoai" CssClass="rd_chon" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="True" OnSelectedIndexChanged="rdbLoai_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="Nhập thông tin mới" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Chọn từ hồ sơ vụ án"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <asp:Panel ID="pnNew" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 120px;">Đối tượng<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="dropLoaiDoiTuong"
                                        CssClass="chosen-select" runat="server" Width="250"
                                        AutoPostBack="true" OnSelectedIndexChanged="dropLoaiDoiTuong_SelectedIndexChanged">
                                        <asp:ListItem Value="0" Text="Cá nhân"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Cơ quan"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Tổ chức"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tư cách tham gia<span class="batbuoc">(*)</span></td>
                                <td style="width: 250px;">
                                    <asp:DropDownList ID="ddlTuCachTGTT"
                                        CssClass="chosen-select" runat="server" Width="250px"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTuCachTGTT_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 93px;">
                                    <asp:Literal ID="lblHoTen" runat="server" Text="Họ tên"></asp:Literal><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtHoten" CssClass="user" runat="server"
                                        MaxLength="250" Width="207px"></asp:TextBox>
                                </td>
                            </tr>
                            <asp:Panel ID="pnNguoiDD" runat="server" Visible="false">
                                <tr>
                                    <td>Người đại diện</td>
                                    <td>
                                        <asp:TextBox ID="txtNDD_HoTen" CssClass="user" runat="server"
                                            MaxLength="250" Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtNDD_ChucVu" CssClass="user" runat="server"
                                            MaxLength="250" Width="207px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>CMND</td>
                                    <td>
                                        <asp:TextBox ID="txtNDD_CMND" CssClass="user" runat="server"
                                            MaxLength="250" Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Điện thoại</td>
                                    <td>
                                        <asp:TextBox ID="txtNDD_Mobile" CssClass="user" runat="server"
                                            MaxLength="250" Width="207px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Email</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNDD_Email" CssClass="user" runat="server"
                                            MaxLength="250" Width="568px"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnCaNhan" runat="server">
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                            <asp:ListItem Value="1" Text="Nam" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user"
                                            MaxLength="10" Width="80px"
                                            AutoPostBack="True" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh
                                    <asp:TextBox ID="txtNamsinh" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="58px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nghề nghiệp</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNgheNghiep" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                        </asp:DropDownList>
                                    </td>
                                    <td>Ngày tham gia</td>
                                    <td>
                                        <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="206px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaythamgia" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnTreViThanhNien" runat="server" Visible="false">
                                <tr>
                                    <td>Trẻ vị thành niên<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdTreViThanhNien" runat="server"
                                            RepeatDirection="Horizontal" AutoPostBack="true"
                                            OnSelectedIndexChanged="rdTreViThanhNien_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <asp:Panel ID="pnTreVTNCo" runat="server" Enabled="false">
                                        <td>Phân loại độ tuổi</td>
                                        <td>
                                            <asp:DropDownList ID="ddlPLTuoi"
                                                CssClass="chosen-select" runat="server" Width="214px">
                                                <asp:ListItem Value="1" Text="Dưới 16 tuổi" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Dưới 16 tuổi bị tổn thương nghiêm trọng về tâm lý"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Từ đủ 16 đến dưới 18 tuổi"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Từ đủ 16 đến dưới 18 tuổi bị tổn thương nghiêm trọng về tâm lý"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </asp:Panel>
                                    <asp:Panel ID="pnTreVTNKhong" runat="server" Visible="true">
                                        <td colspan="2"></td>
                                    </asp:Panel>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pn_daidien" runat="server" Visible="false">
                                <tr>
                                    <td>Tên văn phòng luật sư</td>
                                    <td>
                                        <asp:TextBox ID="txt_TEN_VPLS" CssClass="user"
                                            runat="server" MaxLength="250" Width="240"></asp:TextBox></td>
                                    <td>Đoàn luật sư</td>
                                    <td>
                                        <asp:TextBox ID="txt_DOAN_LS" CssClass="user"
                                            runat="server" MaxLength="250" Width="206"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Số ĐT</td>
                                    <td>
                                        <asp:TextBox ID="txt_NDD_MOBILE" CssClass="user"
                                            runat="server" MaxLength="250" Width="240"></asp:TextBox></td>
                                      <td>Người ký giấy XN</td>
                                  <td>
                                <asp:DropDownList ID="ddlNguoiphancong"   CssClass="chosen-select" runat="server" Width="215px"></asp:DropDownList>
                            <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td>Sổ đăng ký số <span class="batbuoc">(*)</span> </td>
                                    <td>
                                        <asp:TextBox ID="txt_SO_DK" CssClass="user" 
                                            runat="server" MaxLength="250" Width="240"></asp:TextBox></td>
                                    <td>Ngày đăng ký<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txt_NGAY_DK" runat="server" CssClass="user" Width="206px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAY_DK" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_NGAY_DK" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAY_DK" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>

                            </asp:Panel>
                                <asp:Panel ID="pn_daidiencho" runat="server">
                                     <tr >
                                    <td>Đại diện cho</td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddl_BICAO_ID" multiple data-placeholder="...chọn..." class="chosen-select"  Style="width: 572px;" runat="server"  AutoPostBack="True">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                              </asp:Panel>   
                 
                            <tr>
                                <td>Địa chỉ chi tiết</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDiaChiChitiet" CssClass="user"
                                        runat="server" MaxLength="250" Width="563px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnChon" Visible="false" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 125px;"><b>Chọn người TGTT</b></td>
                                <td>
                                    <asp:CheckBoxList ID="chkListTGTT" runat="server" RepeatDirection="Vertical" RepeatColumns="1"></asp:CheckBoxList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" ID="lblMsgChon" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center;">
                                    <asp:Button ID="cmdChonTGTT" runat="server" CssClass="buttoninput" Text="Chọn đưa vào thụ lý Phúc thẩm" OnClick="cmdChonTGTT_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <%--------------------------------------------------------------------%>
            <div class="boxchung">
                <h4 class="tleboxchung">In giấy xác nhận
                 <asp:LinkButton ID="lbtTTBC" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lbtTTBC_Click"></asp:LinkButton></h4>
                <div class="boder" style="padding: 10px;">
                    <asp:Panel ID="pnTTBC" runat="server" Visible="true">
                        <table class="table1">
                            <tr>
                                <td colspan="7">
                                    <div style="float:left">
                                         <asp:Label runat="server" ID="lbthongbao_export" ForeColor="Red"></asp:Label>
                                    </div>
                                    <div style="margin-top: 10px; float: right;" id="divPrintNoibo" runat="server">
                                        <asp:Button ID="btn_GXN_BC" runat="server" Width="225px" padding-left="0px" CssClass="buttonprint" OnClick="btn_GXN_BC_Click" Text="Giấy XN người bảo vệ bị cáo" />
                                        <asp:Button ID="btn_GXN_BH" runat="server" Width="280px" CssClass="buttonprint" OnClick="btn_GXN_BH_Click" Text="Giấy XN người bảo vệ tham gia tố tụng khác" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                            <asp:BoundColumn DataField="TuCachID"  Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("arrID")%>' runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Đối tượng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DoiTuong") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                            <HeaderTemplate>
                                                Tư cách tham gia tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TenTuCachTGTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="240px">
                                            <HeaderTemplate>
                                                Họ và tên
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Địa chỉ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIACHI") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                           <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                               Người ký - Chức vụ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("chucvuchucdanh") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                              <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                               Đại diện cho
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("BICAO_DATA") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>

                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ddlMultiSelect_fu() {
            $('#<%=ddl_BICAO_ID.ClientID %>').chosen().change(function (e, params) {
                var values = $('#<%=ddl_BICAO_ID.ClientID %>').chosen().val();
                console.log(values);
                document.getElementById('<%=lstDataBC.ClientID%>').value = values;
                //anhvh 01/03/2022//
            });
        }
        function ddlMultiSelect_fu_setvalue() {
            var my_val = document.getElementById('<%=lstDataBC.ClientID%>').value;
            var str_array = my_val.split(',');
            $('#<%=ddl_BICAO_ID.ClientID %>').val(str_array).trigger("chosen:updated");
            console.log(str_array);
        }
        function validate() {
            var dropLoaiDoiTuong = document.getElementById('<%=dropLoaiDoiTuong.ClientID%>');
            var loaidoituong = dropLoaiDoiTuong.options[dropLoaiDoiTuong.selectedIndex].value;

            var ddlTuCachTGTT = document.getElementById('<%=ddlTuCachTGTT.ClientID%>');
            var tucachtt = ddlTuCachTGTT.options[ddlTuCachTGTT.selectedIndex].value;

            var hddTuCachTT_BiHai_ID = document.getElementById('<%=hddTuCachTT_BiHai_ID.ClientID%>');
            var ConfigBiHaiID = hddTuCachTT_BiHai_ID.value;

            var temp_hoten = "";
            if (loaidoituong == "0")
                temp_hoten = "Họ tên người tham gia tố tụng";
            else if (loaidoituong == "1")
                temp_hoten = "Tên cơ quan";
            else if (loaidoituong == "0")
                temp_hoten = "Tên tổ chức";
            //alert(temp_hoten);
            //-----------------------------
            var length_value = 0;
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            if (!Common_CheckEmpty(txtHoten.value)) {
                alert('Bạn chưa nhập "' + temp_hoten + '". Hãy kiểm tra lại!');
                txtHoten.focus();
                return false;
            }
            length_value = txtHoten.value.length;
            if (length_value > 250) {
                alert(temp_hoten + ' không nhập quá 250 ký tự. Hãy kiểm tra lại!');
                txtHoten.focus();
                return false;
            }

            //-------------------------------
            var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');
            if (Common_CheckEmpty(txtNgaysinh.value)) {
                if (!CheckDateTimeControl(txtNgaysinh, 'Ngày sinh của người tham gia tố tụng'))
                    return false;
            }
            //-------------------------------
            var txtNamsinh = document.getElementById('<%=txtNamsinh.ClientID%>');
            if (Common_CheckEmpty(txtNamsinh.value)) {
                var CurrentYear = '<%=CurrentYear%>';
                var namsinh = parseInt(txtNamsinh.value);
                if (namsinh > CurrentYear) {
                    alert('Năm sinh phải nhỏ hơn hoặc bằng năm hiện tại. Hãy kiểm tra lại!');
                    txtNamsinh.focus();
                    return false;
                }
            }
            //-------------------------------------
            if (loaidoituong == "0" && tucachtt == ConfigBiHaiID) {
                var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
                msg = 'Mục "Trẻ vị thành niên" bắt buộc phải chọn.';
                msg += 'Hãy kiểm tra lại!';

                if (!CheckChangeRadioButtonList(rdTreViThanhNien, msg))
                    return false;
            }

            //-------------------------------
            var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (Common_CheckEmpty(txtNgaythamgia.value)) {
                if (!CheckDateTimeControl(txtNgaythamgia, 'Ngày tham gia tố tụng'))
                    return false;
            }
            var txtDiaChiChitiet = document.getElementById('<%=txtDiaChiChitiet.ClientID%>');
            if (Common_CheckEmpty(txtDiaChiChitiet.value)) {
                length_value = txtDiaChiChitiet.value.length;
                if (length_value > 250) {
                    {
                        alert('Địa chỉ chi tiết không quá 250 ký tự. Hãy kiểm tra lại!');
                        txtDiaChiChitiet.focus();
                        return false;
                    }
                }
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            ddlMultiSelect_fu();
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ValidListFromHoSoVuAn() {
            var CHK = document.getElementById("<%=chkListTGTT.ClientID%>");
            var checkbox = CHK.getElementsByTagName("input");
            var counter = 0;
            for (var i = 0; i < checkbox.length; i++) {
                if (checkbox[i].checked) {
                    counter++;
                    break;
                }
            }
            if (counter == 0) {
                alert('Bạn chưa chọn người tham gia tố tụng. Hãy chọn lại!');
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
