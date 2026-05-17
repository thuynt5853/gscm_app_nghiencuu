<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WEB.GSTP.TDKT.Ketquabinhxet.Edit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js" type="text/javascript"></script>
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

        .truong {
            border: none !important;
            margin-top: 0px !important;
        }

        .BinhXet_Col1 {
            width: 140px;
        }

        .BinhXet_Col2 {
            width: 275px;
        }

        .BinhXet_Col3 {
            width: 115px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="15" runat="server" />
    <asp:HiddenField ID="hddDanhsachID" Value="0" runat="server" />

    <div class="box">
        <div class="truong">
            <span style="text-transform: uppercase; font-size: 14px; font-weight: bold;">
                <asp:Label ID="LblTenDanhSach" runat="server"></asp:Label>
            </span>
            <div class="boxchung">
                <h4 class="tleboxchung bg_title_group">Thông tin cuộc họp</h4>
                <div class="boder" style="padding: 5px 10px;">
                    <table class="table1">
                        <tr>
                            <td class="BinhXet_Col1"><b>Ngày bắt đầu<span style="color: red;"> (*)</span></b></td>
                            <td class="BinhXet_Col2">
                                <asp:TextBox ID="TxtNgayBatDau" runat="server" CssClass="user" Width="257px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="TxtNgayBatDau" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="TxtNgayBatDau" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td class="BinhXet_Col3"><b>Ngày kết thúc<span style="color: red;"> (*)</span></b></td>
                            <td>
                                <asp:TextBox ID="TxtNgayKetThuc" runat="server" CssClass="user" Width="275px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayKetThuc" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayKetThuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Địa điểm</b></td>
                            <td colspan="3">
                                <asp:TextBox runat="server" ID="TxtDiaDiem" Width="679px" CssClass="user" MaxLength="500"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><b>Thành phần tham dự<span style="color: red;"> (*)</span></b></td>
                            <td colspan="3">
                                <asp:TextBox runat="server" ID="TxtThanhPhanThamDu" Width="677px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><b>Chủ trì cuộc họp<span style="color: red;"> (*)</span></b></td>
                            <td>
                                <asp:TextBox runat="server" ID="TxtChuTri" Width="257px" CssClass="user" MaxLength="250"></asp:TextBox>
                            </td>
                            <td><b>Chức vụ</b></td>
                            <td>
                                <asp:TextBox runat="server" ID="TxtChuTri_CV" Width="275px" CssClass="user" MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Thư ký<span style="color: red;"> (*)</span></b></td>
                            <td>
                                <asp:TextBox runat="server" ID="TxtThuKy" Width="257px" CssClass="user" MaxLength="250"></asp:TextBox>
                            </td>
                            <td><b>Chức vụ</b></td>
                            <td>
                                <asp:TextBox runat="server" ID="TxtThuKy_CV" Width="275px" CssClass="user" MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Nội dung cuộc họp<span style="color: red;"> (*)</span></b></td>
                            <td colspan="3">
                                <asp:TextBox runat="server" ID="TxtNoiDung" Width="677px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><b>Ý kiến tham gia</b></td>
                            <td colspan="3">
                                <asp:TextBox runat="server" ID="TxtYKien" Width="677px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><b>Kết quả cuộc họp<span style="color: red;"> (*)</span></b></td>
                            <td colspan="3">
                                <asp:TextBox runat="server" ID="TxtKetQua" Width="677px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
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
                    </table>
                </div>
            </div>
            <div class="boxchung">
                <h4 class="tleboxchung bg_title_group">Kết quả bình xét</h4>
                <div class="boder" style="padding: 5px 10px;">
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
                                    AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="STT" HeaderText="Thứ tự" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENDOITUONG" HeaderText="Tên đối tượng" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAIDOITUONG" HeaderText="Loại đối tượng" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="88px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="88px">
                                            <HeaderTemplate>Loại đề nghị</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hddDoiTuongID" runat="server" Value='<%#Eval("ID") %>' />
                                                <asp:Label ID="LblLoaiDeNghi" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="HINHTHUC" HeaderText="Hình thức" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="126px">
                                            <HeaderTemplate>Loại đề nghị (Kết quả)</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="DropLoaiDeNghi_KQ" Width="108px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropLoaiDeNghi_KQ_SelectedIndexChanged">
                                                    <asp:ListItem Text="Khen thưởng" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="Kỷ luật" Value="2"></asp:ListItem>
                                                    <asp:ListItem Text="Thi đua" Value="3"></asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                            <HeaderTemplate>Hình thức (Kết quả)</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="DropHinhThuc_KQ" Width="286px" runat="server" CssClass="chosen-select"></asp:DropDownList>
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
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="boxchung">
                <div style="padding: 5px 10px;">
                    <table class="table1">
                        <tr>
                            <td class="BinhXet_Col1"></td>
                            <td>
                                <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                                <asp:Button ID="BtnXoa" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="BtnXoa_Click" />
                                <asp:Button ID="BtnQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Label runat="server" ID="Lblthongbao" CssClass="msg_error"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
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
        function Validate() {
            var TxtNgayBatDau = document.getElementById('<%=TxtNgayBatDau.ClientID%>');
            var Length = TxtNgayBatDau.value.trim().length;
            if (Length == 0) {
                alert('Ngày bắt đầu không được để trống. Hãy nhập lại.');
                TxtNgayBatDau.focus();
                return false;
            } else {
                if (!Common_IsTrueDate(TxtNgayBatDau.value)) {
                    TxtNgayBatDau.focus();
                    return false;
                }
                var now = new Date();
                var temp = TxtNgayBatDau.value.split('/');
                var NgayBatDau = new Date(temp[2], temp[1] - 1, temp[0]);
                if (now < NgayBatDau) {
                    alert('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày hiện tại.');
                    TxtNgayBatDau.focus();
                    return false;
                }
                var TxtNgayKetThuc = document.getElementById('<%=TxtNgayKetThuc.ClientID%>');
                Length = TxtNgayKetThuc.value.trim().length;
                if (Length == 0) {
                    alert('Ngày kết thúc không được để trống. Hãy nhập lại.');
                    TxtNgayKetThuc.focus();
                    return false;
                } else {
                    if (!Common_IsTrueDate(TxtNgayKetThuc.value)) {
                        TxtNgayKetThuc.focus();
                        return false;
                    }
                    temp = TxtNgayKetThuc.value.split('/');
                    var NgayKetThuc = new Date(temp[2], temp[1] - 1, temp[0]);
                    if (now < NgayKetThuc) {
                        alert('Ngày kết thúc phải nhỏ hơn hoặc bằng ngày hiện tại.');
                        TxtNgayKetThuc.focus();
                        return false;
                    }
                    if (NgayBatDau > NgayKetThuc) {
                        alert('Ngày kết thúc phải nhỏ hơn hoặc bằng ngày bắt đầu!');
                        TxtNgayKetThuc.focus();
                        return false;
                    }
                }
            }
            var TxtThanhPhanThamDu = document.getElementById('<%=TxtThanhPhanThamDu.ClientID%>');
            Length = TxtThanhPhanThamDu.value.trim().length;
            if (Length == 0) {
                alert('Thành phần tham dự không được để trống. Hãy nhập lại.');
                TxtThanhPhanThamDu.focus();
                return false;
            } else if (Length > 4000) {
                alert('Thành phần tham dự không được quá 4000 ký tự. Hãy nhập lại.');
                TxtThanhPhanThamDu.focus();
                return false;
            }
            var TxtChuTri = document.getElementById('<%=TxtChuTri.ClientID%>');
            Length = TxtChuTri.value.trim().length;
            if (Length == 0) {
                alert('Chủ trì cuộc họp không được để trống. Hãy nhập lại.');
                TxtChuTri.focus();
                return false;
            } else if (Length > 250) {
                alert('Chủ trì cuộc họp không được quá 250 ký tự. Hãy nhập lại.');
                TxtChuTri.focus();
                return false;
            }
            var TxtThuKy = document.getElementById('<%=TxtThuKy.ClientID%>');
            Length = TxtThuKy.value.trim().length;
            if (Length == 0) {
                alert('Tên thư ký không được để trống. Hãy nhập lại.');
                TxtThuKyv.focus();
                return false;
            } else if (Length > 250) {
                alert('Tên thư ký không quá 250 ký tự. Hãy nhập lại.');
                TxtThuKy.focus();
                return false;
            }
            var TxtNoiDung = document.getElementById('<%=TxtNoiDung.ClientID%>');
            Length = TxtNoiDung.value.trim().length;
            if (Length == 0) {
                alert('Nội dung cuộc họp không được để trống. Hãy nhập lại.');
                TxtNoiDung.focus();
                return false;
            } else if (Length > 4000) {
                alert('Nội dung cuộc họp không quá 4000 ký tự. Hãy nhập lại.');
                TxtNoiDung.focus();
                return false;
            }
            var TxtKetQua = document.getElementById('<%=TxtKetQua.ClientID%>');
            Length = TxtKetQua.value.trim().length;
            if (Length == 0) {
                alert('Kết quả cuộc họp không được để trống. Hãy nhập lại.');
                TxtKetQua.focus();
                return false;
            } else if (Length > 4000) {
                alert('Kết quả cuộc họp không quá 4000 ký tự. Hãy nhập lại.');
                TxtKetQua.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
