<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.TDKT.DangKyThiDuaKhenThuong.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .msg_error {
            text-align: left !important;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .img_Xoa {
            width: 12px;
            height: 12px;
            margin-left: 5px;
        }

        .KhenThuong_Col1 {
            width: 108px;
        }

        .KhenThuong_Col2 {
            width: 300px;
        }

        .KhenThuong_Col3 {
            width: 75px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="15" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="4">
                            <asp:Button ID="BtnThemMoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="BtnThemMoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Đơn vị</b></td>
                        <td colspan="3">
                            <asp:DropDownList ID="DropToaAn" Width="535px" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Tên danh sách</b></td>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="TxtTenDanSach" Width="527px" CssClass="user" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="KhenThuong_Col1"><b>Loại đề nghị</b></td>
                        <td class="KhenThuong_Col2">
                            <asp:DropDownList ID="DropLoaiDeNghi" Width="278px" runat="server" CssClass="chosen-select check">
                                <asp:ListItem Text="--- Chọn ---" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Thi đua" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Khen thưởng" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Kỷ luật" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td class="KhenThuong_Col3"><b>Năm</b></td>
                        <td>
                            <asp:TextBox ID="TxtNam" runat="server" CssClass="user align_right" Width="137px" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                    <%--<tr>
                        <td><b>Số QĐ<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtSoQD" Width="90%" CssClass="user" MaxLength="100"></asp:TextBox></td>
                        <td><b>Ngày QĐ<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox ID="TxtNgayQD" runat="server" CssClass="user" Width="136px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td><b>Người lập</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtNguoiLap" Width="270px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                        <td><b>Ngày lập</b></td>
                        <td>
                            <asp:TextBox ID="TxtNgayLap" runat="server" CssClass="user" Width="136px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="TxtNgayLap" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="TxtNgayLap" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Người duyệt</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtNguoiDuyet" Width="270px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                        <td><b>Chức vụ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtChucVu" Width="136px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <%--<tr>
                        <td><b>Tệp đính kèm</b></td>
                        <td colspan="3">
                            <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                            <asp:LinkButton ID="LbtDownload" runat="server" OnClick="LbtDownload_Click" Text=""></asp:LinkButton>
                            <asp:ImageButton ID="ImgXoa" runat="server" ImageUrl="~/UI/img/delete.png" OnClick="ImgXoa_Click" Visible="false" CssClass="img_Xoa" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="BtnTimkiem" runat="server" Style="margin-top: 10px;" CssClass="buttoninput" Text="Tìm kiếm" OnClick="BtnTimkiem_Click" />
                            <asp:Button ID="BtnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="BtnLamMoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="Lblthongbao" CssClass="msg_error"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Panel ID="PanData" runat="server">
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
                                    AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="40px" ItemStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thứ tự</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tên danh sách</HeaderTemplate>
                                            <ItemTemplate><%#Eval("TEN_DANH_SACH") %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="270px" ItemStyle-Width="270px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Đơn vị</HeaderTemplate>
                                            <ItemTemplate><%#Eval("TENDONVI") %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-Width="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Năm</HeaderTemplate>
                                            <ItemTemplate><%#Eval("NAM") %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Đối tượng đề nghị</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtDanhSach" runat="server" Text="Danh sách đối tượng" CausesValidation="false"
                                                    CommandName="DanhSach" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") + ";" + Eval("TOAANID") + ";" + Eval("LOAI_DE_NGHI") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-Width="250px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtDownload" runat="server" Text='<%#Eval("FILE_TEN") %>' CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") + ";" + Eval("TOAANID") + ";" + Eval("LOAI_DE_NGHI") %>' CssClass="TenFile_css"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                                    CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") + ";" + Eval("TOAANID") + ";" + Eval("LOAI_DE_NGHI") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                                <asp:LinkButton ID="LbtXoa" runat="server" Text="Xóa" CausesValidation="false"
                                                    CommandName="Xoa" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") + ";" +Eval("TOAANID") + ";" + Eval("LOAI_DE_NGHI") %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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

    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
    </script>
</asp:Content>
