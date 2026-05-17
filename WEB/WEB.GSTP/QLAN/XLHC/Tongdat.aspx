<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Tongdat.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Tongdat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsTructuyen" Value="0" runat="server" />
    <asp:HiddenField ID="hddarrDuongsuTructuyen" Value="" runat="server" />
    <asp:HiddenField ID="CountItem" Value="0" runat="server" />
    <style type="text/css">
        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin tống đạt</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 160px;">Hình thức nộp đơn khởi kiện</td>
                            <td colspan="3">
                                <b>
                                    <asp:Literal ID="lstHinhthucgui" runat="server"></asp:Literal></b>
                            </td>
                        </tr>
                        <tr>
                            <td>Đăng ký nhận tống đạt qua hệ thống ĐKK?</td>
                            <td colspan="3">
                                <b>
                                    <asp:Literal ID="lstDKNhanTD" runat="server"></asp:Literal></b>
                            </td>
                        </tr>
                        <tr>
                            <td>Văn bản tống đạt<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <div style="width: 380px; float: left;">
                                    <asp:DropDownList ID="ddlBieumau" CssClass="chosen-select" runat="server" Width="661px"  OnSelectedIndexChanged="ddlBieumau_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Literal ID="lstTenBM" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                        <tr id="trFile" runat="server">
                            <td>Tệp đính kèm gửi trực tuyến</td>
                            <td colspan="3">
                                <div runat="server" id="trThemFile" visible="false">
                                    <asp:HiddenField ID="hddFilePath" runat="server" />
                                    <asp:CheckBox ID="chkKySo" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                    <br />
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px; float: left;">
                                        <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                        <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                        <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                        </ul>
                                    </div>
                                    <div id="zonekythuong" style="display: none; float: left; margin-top: 10px; width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                        <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    </div>
                                    <br />
                                </div>
                                <asp:HiddenField ID="hddFile" Value="0" runat="server" />
                                <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                        </tr>
                        <tr runat="server" id="trVKS" visible="false">
                            <td style="width: 160px;">+ Tống đạt tới Viện kiểm sát?</td>
                            <td style="width: 200px;">
                                <asp:RadioButtonList ID="rdbIsVKS" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbIsVKS_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Selected="True">Chưa gửi</asp:ListItem>
                                    <asp:ListItem Value="1">Đã gửi</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="text-align: right; width: 65px;">
                                <asp:Label ID="lblVKSNgaygui" Visible="false" runat="server" Text="Ngày gửi"></asp:Label>
                            </td>
                            <td>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtVKS_Ngaygui" runat="server" Visible="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtVKS_Ngaygui" Format="dd/MM/yyyy" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtVKS_Ngaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                </div>
                                <div id="div_VKS_NgayNhan" runat="server" visible="false" style="float: left; width: 65px; margin-left: 10px; margin-top: 7px;">Ngày nhận</div>
                                <div>
                                    <asp:TextBox ID="txtVKS_NgayNhan" runat="server" Visible="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtVKS_NgayNhan" Format="dd/MM/yyyy" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtVKS_NgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                </div>
                            </td>
                        </tr>
                        <tr runat="server" id="trDuongsu" visible="false">
                            <td style="width: 160px;">+ Tống đạt tới các đương sự qua phương thức trực tiếp, bưu điện,...?</td>
                            <td colspan="3">
                                <asp:DataGrid ID="dgTructiep" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="661px" OnItemDataBound="dgTructiep_ItemDataBound">
                                    <Columns>
                                         <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                        <asp:BoundColumn DataField="TUCACHTOTUNG_MA" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HINHTHUCGUI" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="QUOCGIA" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="COQUAN" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NOIDUNG" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="KETQUAUTTP" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TONGDAT_DOITUONG" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên đương sự
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENDUONGSU") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="110px">
                                            <HeaderTemplate>
                                                Tư cách tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTCTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Đã gửi?
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkIsSend" runat="server" Checked='<%# GetNumber(Eval("TRANGTHAI"))%>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkIsSend_CheckChange" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                                            <HeaderTemplate>
                                                Ngày gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgaygui" Visible='<%# GetNumber(Eval("TRANGTHAI"))%>' runat="server" Text='<%# GetTextDate(Eval("NGAYGUI"))%>' CssClass="user" Width="90px" MaxLength="10" AutoPostBack="true"  OnTextChanged="txtNgaygui_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgaygui_CalendarExtender" runat="server" TargetControlID="txtNgaygui" Format="dd/MM/yyyy" />
                                                <cc1:MaskedEditExtender ID="txtNgaygui_MaskedEditExtender3" runat="server" TargetControlID="txtNgaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="126px">
                                            <HeaderTemplate>
                                                Ngày nhận / Niêm yết
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgayNhan" Visible='<%# GetNumber(Eval("TRANGTHAI"))%>' runat="server" Text='<%# GetTextDate(Eval("NGAYNHANTONGDAT"))%>' CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayNhan_CalendarExtender" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" />
                                                <cc1:MaskedEditExtender ID="txtNgayNhan_MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Hình thức gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlHinhthuc" Visible ="false" CssClass="chosen-select" runat="server" Width="100px" AutoPostBack="True" OnSelectedIndexChanged="ddlHinhthuc_SelectedIndexChanged">  
                                                    <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Qua bưu điện"  Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Tự UTTP"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="Cấp trên UTTP"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Niêm yết công khai"></asp:ListItem>
                                                </asp:DropDownList> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">
                                            <HeaderTemplate>
                                                Thông tin ủy thác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="display:flex">
                                                    <span style="width:60px"><asp:Label id="lblQuocGia" Text="Quốc gia<span style='color:red'>*</span>" runat="server" /></span>
                                                    <span>
                                                        <asp:DropDownList ID="ddlQuocGiaUT" CssClass="chosen-select" runat="server" Width="105px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuocGiaUT_SelectedIndexChanged">
                                                            <asp:ListItem Value="0" Text="---Chọn---"></asp:ListItem>
                                                        </asp:DropDownList>

                                                    </span>
                                                </div>
                                                <div style="display:flex">
                                                    <span style="width:60px"><asp:Label id="lblCoquan" Text="Cơ quan<span style='color:red'>*</span>" runat="server" /></span>
                                                    <span><asp:TextBox ID="txtCoquan"  TextMode="multiline"  runat="server" Text='' CssClass="user" Width="100px"></asp:TextBox></span>
                                                </div>
                                                <div style="display:flex">
                                                    <span style="width:60px"><asp:Label id="lblNoidung" Text="Nội dung" runat="server" /></span>
                                                    <span><asp:TextBox id="txtNoidung" TextMode="multiline" CssClass="user" Width="100px" Columns="50" Rows="1" runat="server" /></span>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                                            <HeaderTemplate>
                                                Kết quả UTTP
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlketquauttp" CssClass="chosen-select"  runat="server" Width="120px" AutoPostBack="True" OnSelectedIndexChanged="ddlketquauttp_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                       
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                        </tr>
                        <tr runat="server" id="trTructuyen" visible="false">
                            <td>+ Tống đạt tới các đương sự qua phương thức trực tuyến?
                            </td>
                            <td colspan="3">
                                <asp:DataGrid ID="dgTructuyen" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="661px">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TUCACHTOTUNG_MA" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên đương sự
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENDUONGSU") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="110px">
                                            <HeaderTemplate>
                                                Tư cách tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTCTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Đã gửi?
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Literal ID="lstTT" runat="server" Text='<%# (Eval("TRANGTHAI")+"")=="1"?"Đã gửi":"Chưa gửi"%>'></asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                                            <HeaderTemplate>
                                                Ngày gửi / nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# GetTextDate(Eval("NGAYGUI"))%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <div>
                                    <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return validate();" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="boxchung">
                <h4 class="tleboxchung">Các văn bản đã tống đạt</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>
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
                                        <asp:TemplateColumn HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên văn bản
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENBM") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="98px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TINHTRANGNHANVB" HeaderText="Đã nhận/ Tổng số" HeaderStyle-Width="104px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="102px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Xem chi tiết & Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
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

                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">       
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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
