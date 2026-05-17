<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Phuctham.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />

    <style>
        .CustomWidth {
        }

        .modalPopup .header {
            background-color: #a4212a;
            height: 30px;
            color: White;
            line-height: 22px;
            text-align: center;
            font-weight: bold;
        }
    </style>

    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin thụ lý</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 125px;">Trường hợp thụ lý</td>
                            <td style="width: 265px;">
                                <asp:DropDownList ID="ddlLoaiThuLy" CssClass="chosen-select" runat="server" Width="250px">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 160px;"></td>
                            <td>
                                <asp:CheckBox ID="cbUTTP" Checked="false" runat="server" Text="Ủy thác tư pháp đi" /></td>
                        </tr>
                        <tr>
                            <td>Quan hệ pháp luật<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged"></asp:DropDownList>
                                <asp:DropDownList ID="ddlLoaiQuanhe" Visible="false" CssClass="chosen-select" runat="server" Width="300px">
                                    <asp:ListItem Value="1" Text="Tranh chấp"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Yêu cầu"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Ngày thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="242px" MaxLength="10"
                                    AutoPostBack="True" OnTextChanged="txtNgayThuLy_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Số thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtSoThuly" CssClass="user" runat="server"
                                    Width="242px" MaxLength="250"></asp:TextBox>
                                <asp:DropDownList ID="ddlSothuly" CssClass="user" runat="server" Width="186px">
                                </asp:DropDownList>
                                <asp:DropDownList ID="ddlStlPhu" CssClass="user" runat="server" Width="54px">
                                    <asp:ListItem Value="" Text="" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="A" Text="A"></asp:ListItem>
                                    <asp:ListItem Value="B" Text="B"></asp:ListItem>
                                    <asp:ListItem Value="C" Text="C"></asp:ListItem>
                                    <asp:ListItem Value="D" Text="D"></asp:ListItem>
                                    <asp:ListItem Value="E" Text="E"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Số bút lục</td>
                            <td>
                                <asp:TextBox ID="txtSoButLuc" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                            </td>
                            <td>Người kiểm hồ sơ</td>
                            <td>
                                <asp:DropDownList ID="ddlCanbokiemhoso" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="boxchung">
                <h4 class="tleboxchung"></h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 125px;">Số thông báo</td>
                            <td style="width: 262px;">
                                <asp:TextBox ID="txtSothongbao" runat="server" CssClass="user" Width="242px" onkeypress="return isNumber(event);"></asp:TextBox>
                            </td>
                            <td style="width: 162px;">Ngày thông báo<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgaythongbao" runat="server" CssClass="user" Width="242px" MaxLength="10"
                                    AutoPostBack="True" OnTextChanged="txtNgaythongbao_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaythongbao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaythongbao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 162px;">Người ký<span class="batbuoc">(*)</span></td>
                            <td style="width: 242px;">
                                <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="242px"></asp:DropDownList>
                            </td>
                            <td style="width: 125px;"></td>
                            <td style="width: 242px;"></td>
                        </tr>
                        <asp:Panel runat="server" ID="pnDownload" Visible="false">
                            <tr>
                                <td>Tệp đính kèm</td>
                                <td colspan=" 3">
                                    <asp:HiddenField ID="hddFilePath" runat="server" />
                                    <asp:CheckBox ID="chkKySo" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                    <br />
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;">
                                        <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                        <button type="button" class="buttonkyso" style="display: none;" id="_Config" onclick="vgca_show_config();"></button>
                                        <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                        </ul>
                                    </div>
                                    <div id="zonekythuong" style="display: none; margin-top: 10px; width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                        <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    </div>
                                    <%--</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>--%>
                                    <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                            </tr>
                        </asp:Panel>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            <asp:Button ID="btnLichsuXoaThuly" runat="server" CssClass="buttoninput" Text="Lịch sử xóa" OnClick="btnLichsuXoaThuly_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
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
                                        <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Số thụ lý
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOTHULY") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHULY" HeaderText="Ngày thụ lý" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENTRUONGHOPTHULY" HeaderText="Trường hợp thụ lý"
                                            HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' />
                                                <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoaSothulyKhongSuDungLai" runat="server" CausesValidation="false" Text="Xóa số thụ lý" ForeColor="#0e7eee"
                                                    CommandName="XoaSothulyKhongSuDungLai" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
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

    <div runat="server" id="modalpopupCapnhat" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mp1" BehaviorID="mp1_Capnhat"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="modalpopupCapnhat"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 150px; width: 550px;">
        <div class="box_nd" style="width: 500px; display: none;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="pnCapnhat_Tieude" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <asp:HiddenField ID="hddXoa_SelectedIndex" runat="server" Value="0" />
                <asp:HiddenField ID="hddThulyID" runat="server" Value="0" />

                <div>
                    <div>
                        <table>
                            <tr>

                                <td>Lý do xóa<span class="batbuoc">(*)</span></td>
                                <td style="padding-left: 5px;">
                                    <asp:DropDownList ID="ddlLydoXoaSothuly" CssClass="user" runat="server" Style="width: 300px; text-align: center">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <asp:Button ID="btnSaveLydoXoa" runat="server" CssClass="buttoninput" Text="Xóa và đóng" OnClick="btnSaveLydoXoa_Insert" OnClientClick="javascript:HideModalPopup();" />
                                    <asp:Button ID="btnClose" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="javascript:HideModalPopup();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>



    <div runat="server" id="modalpopupLichsuXoaThuly" style="display: none; visibility: hidden; position: absolute!important;"></div>
    <cc1:ModalPopupExtender ID="mdLichsuXoaThuly" BehaviorID="mp_LichsuXoaThuly"
        runat="server" PopupControlID="pnLichsuXoaThuly"
        TargetControlID="modalpopupLichsuXoaThuly"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnLichsuXoaThuly" runat="server" align="center" CssClass="modalPopup" Style="height: 500px; width: 550px; overflow-y: scroll;">

        <div class="box_nd" style="width: 500px;">
            <div class="truong">
                <div>
                    <div>
                        <table>
                            <tr>
                                <td>
                                    <asp:DataGrid ID="dgLichsuXoaThuly" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%">
                                        <Columns>
                                            <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    TT
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Container.DataSetIndex + 1 %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Số/ngày thụ lý
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("SOTHULY") %><br />
                                                    <%# Eval("NGAYTHULY", "{0:dd/MM/yyyy}") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Lý do xóa
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("LYDO") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Người xóa/Ngày xóa
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TAIKHOANXOA") %><br />
                                                    <%#Eval("NGAYXOA") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                        <ItemStyle CssClass="chan"></ItemStyle>
                                        <PagerStyle Visible="false"></PagerStyle>
                                    </asp:DataGrid>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="box_nd" style="width: 500px;">
            <div class="truong">

                <div>
                    <div>
                        <table>
                            <tr>
                                <td style="text-align: left;" colspan="6">
                                    <asp:Button ID="btnCloseLichsuXoaThuly" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="javascript:HideModalPopup();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function HideModalPopup() {
            $find("mp1_Capnhat").hide();
            return false;
        }
    </script>

    <script type="text/javascript">
        function ValidInputData() {
            var txtNgaythuly = document.getElementById('<%=txtNgaythuly.ClientID%>');
            var lengthNgayThuLy = txtNgaythuly.value.trim().length;
            if (lengthNgayThuLy == 0) {
                alert('Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy).');
                txtNgaythuly.focus();
                return false;
            }
            if (lengthNgayThuLy > 0) {
                var arr = txtNgaythuly.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy).');
                    txtNgaythuly.focus();
                    return false;
                }
            }
            var txtSoThuly = document.getElementById('<%=txtSoThuly.ClientID %>');
            var lengthSoThuLy = txtSoThuly.value.trim().length;
            if (lengthSoThuLy == 0) {
                alert('Bạn phải nhập số thụ lý!');
                txtSoThuly.focus();
                return false;
            }
            if (lengthSoThuLy > 50) {
                alert('Số thụ lý không được quá 50 ký tự. Hãy nhập lại!');
                txtSoThuly.focus();
                return false;
            }
<%--            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            if (txtTuNgay.value.trim().length > 0) {
                var arr = txtTuNgay.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tháng theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            if (txtDenNgay.value.trim().length > 0) {
                var arr = txtDenNgay.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tháng theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }--%>
            <%--var txtGhichu = document.getElementById('<%=txtGhichu.ClientID %>');
            if (txtGhichu.value.trim().length > 250) {
                alert('Ghi chú không được quá 250 ký tự. Hãy nhập lại!');
                txtGhichu.focus();
                return false;
            }--%>
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var count_file = 0;
        function CheckKyso() {
            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');
            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }
        }
        function VerifyPDFCallBack(rv) {

        }
        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;
            var json_prms = JSON.stringify(prms);
            vgca_verify_pdf(json_prms, VerifyPDFCallBack);
        }
        function SignFileCallBack1(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                var new_item = document.createElement("li");
                new_item.innerHTML = received_msg.FileName;
                hddFilePath.value = received_msg.FileServer;
                //-------------Them icon xoa file------------------
                var del_item = document.createElement("img");
                del_item.src = '/UI/img/xoa.gif';
                del_item.style.width = "15px";
                del_item.style.margin = "5px 0 0 5px";
                del_item.onclick = function () {
                    if (!confirm('Bạn muốn xóa file này?')) return false;
                    document.getElementById("file_name").removeChild(new_item);
                }
                del_item.style.cursor = 'pointer';
                new_item.appendChild(del_item);

                document.getElementById("file_name").appendChild(new_item);
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }
        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
            var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }

    </script>
</asp:Content>
