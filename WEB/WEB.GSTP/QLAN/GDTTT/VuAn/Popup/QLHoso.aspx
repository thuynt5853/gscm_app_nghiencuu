<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="QLHoso.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.QLHoso" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý hồ sơ</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>

    <style>
        body {
            width: 96%;
            margin-left: 2%;
            min-width: 0px;
            padding-top: 5px;
        }

        .tleboxchung {
            padding: 5px 5px;
            top: 5px;
            border: solid 0px #a2c2a8;
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                <asp:HiddenField ID="hddVuAn_ToaAnID" runat="server" Value="0" />
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />

                <div class="box">
                    <div class="form_tt">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin vụ án</h4>
                            <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                                <table class="table_info_va">
                                    <tr>
                                        <td style="width: 110px;">Vụ án:</td>
                                        <td colspan="3" style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtTenVuan" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số thụ lý:</td>
                                        <td style="width: 250px;"><b>
                                            <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal></b>
                                        </td>
                                        <td style="width: 105px">Ngày thụ lý:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số BA/QĐ:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal></b>
                                        </td>
                                        <td>Ngày BA/QĐ:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <asp:Panel ID="pnNguyendo" runat="server">
                                        <td style="vertical-align: top;">Nguyên đơn/ Người khởi kiện:</td>
                                         </asp:Panel>
                                        <asp:Panel ID="pnBicaoDv" runat="server"  Visible ="false">
                                            <td style="vertical-align: top;">Bị cáo đầu vụ:</td>
                                         </asp:Panel>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                        </td>
                                        <asp:Panel ID="pnBidon" runat="server">
                                        <td style="vertical-align: top;">Bị đơn/ Người  bị kiện:</td>
                                        </asp:Panel>
                                        <asp:Panel ID="pnBicaoKN" runat="server" Visible ="false">
                                            <td style="vertical-align: top;">Bị cáo khiếu nại:</td>
                                        </asp:Panel>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------------------->
                        <div style="float: left; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Quản lý hồ sơ</h4>
                            <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                                <table class="table1">

                                    <tr>
                                        <td style="width: 110px;">Loại phiếu<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:DropDownList ID="dropLoai"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropLoai_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="250">
                                                <asp:ListItem Value="0" Text="Phiếu mượn" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Phiếu trả"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Phiếu chuyển"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Nhận hồ sơ"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Công văn XM,BS"></asp:ListItem>
                                                <asp:ListItem Value="5" Text="Công văn khác"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr runat="server" id="donvi_hs">
                                        <td>Đơn vị giữ hồ sơ ?</td>
                                        <td colspan="2">
                                            <asp:RadioButtonList ID="rdLoaiDV" runat="server" Font-Bold="true"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdLoaiDV_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Selected="True" Text="Tòa án nhân dân"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Viện kiểm sát"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <%--<asp:Label ID="lblDonVi" runat="server" Text="Tòa án"></asp:Label>--%>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="dropToaAn_VKS"
                                                CssClass="chosen-select" runat="server" Width="238">
                                            </asp:DropDownList>
                                            <asp:TextBox ID="txtToaAn_VKS" CssClass="user"
                                                runat="server" MaxLength="250" Width="230px" Visible="false"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Cán bộ</td>
                                        <td>
                                            <asp:DropDownList ID="dropCanBo"
                                                CssClass="chosen-select" runat="server" Width="250"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropCanBo_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblHoTen" runat="server">Họ tên</asp:Label><asp:Literal ID="lttValidHoTen" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtCanBo" CssClass="user"
                                                runat="server" MaxLength="250" Width="230px"></asp:TextBox>

                                        </td>
                                    </tr>
                                    <tr>
                                        
                                        <td>
                                            <asp:Label ID="lblNgayTH" runat="server" Text="Ngày lập phiếu"></asp:Label>
                                            <span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayTao" runat="server" CssClass="user"
                                                AutoPostBack="true" OnTextChanged="txtNgayTao_TextChanged"
                                                Width="242px" MaxLength="10" ></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayTao" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayTao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayTao" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                        <td style="width: 105px">Số phiếu <span class="batbuoc">
                                            <asp:Label ID="lbl_SoPhieu" runat="server" Text="(*)"></asp:Label></span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoPhieu" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="230px" MaxLength="10"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Người ký<span class="batbuoc">
                                            <asp:Label ID="lbl_NguoiKy" runat="server" Text="(*)"></asp:Label></span></td>
                                        <td>
                                            <asp:DropDownList ID="dropNguoiKy"
                                                CssClass="chosen-select" runat="server" Width="250" AutoPostBack="true">
                                            </asp:DropDownList>
                                        </td>

                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhiChu" runat="server" CssClass="user"
                                                Width="242px"></asp:TextBox></td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                                                Text="Lưu"
                                                OnClientClick="return validate();" OnClick="cmdUpdateAndNext_Click" />
                                            <asp:Button ID="cmdPrinBM" runat="server"
                                                CssClass="buttoninput" Text="Lưu & In"
                                                OnClick="cmdPrinBM_Click" OnClientClick="return validate();" />

                                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                                Text="Làm mới" OnClick="cmdLamMoi_Click" />

                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                                            <div class="phantrang">
                                                <div class="sobanghi" style="width: 40%; font-weight: bold; text-transform: uppercase;">
                                                    Danh sách 
                                                </div>
                                                <div style="float: right;">
                                                    <div>
                                                        <asp:Button ID="cmdPrinDS" runat="server"
                                                            CssClass="buttoninput"
                                                            Text="In danh sách" OnClientClick="PrintList()" />
                                                        <div style="display: none;">
                                                            <asp:Button ID="cmdPrint2" runat="server" CssClass="buttoninput"
                                                                Text="Làm mới" OnClick="cmdPrint_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:Panel ID="pnPagingTop" runat="server">
                                                        <div class="sotrang" style="width: 55%; display: none;">
                                                            <asp:TextBox ID="txtTextSearch" CssClass="user"
                                                                placeholder="Nhập tên cán bộ muốn tìm kiếm"
                                                                runat="server" MaxLength="250" Width="242px" Height="24px"></asp:TextBox>
                                                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                                                Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                                                            <div style="display: none;">
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
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Loại phiếu</strong></div>
                                                    </td>
                                                    <td width="80px">
                                                        <div align="center"><strong>Số phiếu</strong></div>
                                                    </td>
                                                    <td width="80px">
                                                        <div align="center"><strong>Ngày</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Cán bộ</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Tòa án / VKS</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Ghi chú</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><%# Eval("STT") %></div>
                                                            </td>
                                                            <td><%#Eval("LoaiPhieu") %></td>
                                                            <td><%# Eval("SoPhieu") %></td>
                                                            <td><%# Eval("NgayTao") %></td>
                                                            <td><%# Eval("TenCanBo") %></td>
                                                            <td><%#Eval("DVMuonHS") %></td>
                                                            <td><%#Eval("GHICHU") %>
                                                                <%--<%#  (Convert.ToDecimal( Eval("OldVuAnID") )>0)? ("Hồ sơ được mượn từ vụ án số BA: "+ Eval("SoAnPhucTham")):""  %>--%></td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:HiddenField ID="hddLoaiPhieuID" runat="server" Value='<%#Eval("LoaiPhieuID") %>' />
                                                                    <asp:LinkButton ID="lkPrint" runat="server"
                                                                        Text="In phiếu" ForeColor="#0e7eee" Visible='<%# Convert.ToInt16( Eval("LoaiPhieuID")+"")==0? true:false %>'
                                                                        CommandName="Print" CommandArgument='<%#Eval("ID") +","+ Eval("LoaiPhieuID") %>'></asp:LinkButton>
                                                                    <br />
                                                                    <asp:LinkButton ID="lkSua" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
                                            <asp:Panel ID="pnPagingBottom" runat="server">
                                                <div class="phantrang_bottom">
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

                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
    <script>
        function PrintList() {
            var loaibm = 'ds';
            $("#<%= cmdPrint2.ClientID %>").click();
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso&loai=" + loaibm
                + "&vID=<%=Request["vID"] %>";
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }

        function Print(hosoID, type) {
            //alert(hosoID);
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso";
            if (type == 1)
                pageURL += "&loai=mHS" + "&vID=<%=Request["vID"] %>&gID=" + hosoID;
            else
                pageURL += "&loai=bm" + "&vID=<%=Request["vID"] %>&hsID=" + hosoID;
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        }

        function validate() {
            var dropLoai = document.getElementById('<%=dropLoai.ClientID%>');
            var loai = dropLoai.options[dropLoai.selectedIndex].value;
            var loai_ngay = "Ngày lập phiếu";
            if (loai == 0)
            {
                loai_ngay += " mượn";
                var dropNguoiKy = document.getElementById('<%=dropNguoiKy.ClientID%>');
                var val = dropNguoiKy.options[dropNguoiKy.selectedIndex].value;
                if (val == 0) {
                    alert('Bạn chưa nhập tên người ký. Hãy kiểm tra lại!');
                    return false;
                }
            }
            else if (loai == 1)
                loai_ngay += " trả";
            else if (loai == 2)
                loai_ngay += " chuyển";
            else if (loai == 3)
                loai_ngay += " nhận";
            //--------------------------------
            var txtSoPhieu = document.getElementById('<%=txtSoPhieu.ClientID%>');
            if (!Common_CheckEmpty(txtSoPhieu.value) && loai != 3) {
                alert('Bạn chưa nhập số phiếu. Hãy kiểm tra lại!');
                txtSoPhieu.focus();
                return false;
            }
            var txtNgayTao = document.getElementById('<%=txtNgayTao.ClientID%>');
            if (!CheckDateTimeControl(txtNgayTao, loai_ngay))
                return false;
            //-------------------------
            var dropCanBo = document.getElementById('<%=dropCanBo.ClientID%>');
            var val = dropCanBo.options[dropCanBo.selectedIndex].value;
            if (val == 0) {
                var txtCanBo = document.getElementById('<%=txtCanBo.ClientID%>');
                if (!Common_CheckEmpty(txtCanBo.value)) {
                    alert('Bạn chưa nhập tên cán bộ. Hãy kiểm tra lại!');
                    txtCanBo.focus();
                    return false;
                }
            }
            return true;
        }

    </script>
    <script>
        function ReloadParent() {
          //  var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            window.onunload = function (e) {
                opener.LoadDsDon();
            };
        }
    </script>
    <script>

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

    </script>

    <script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>
</body>
</html>
