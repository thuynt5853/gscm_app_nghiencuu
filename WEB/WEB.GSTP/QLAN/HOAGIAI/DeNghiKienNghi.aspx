<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DeNghiKienNghi.aspx.cs" Inherits="WEB.GSTP.QLAN.HOAGIAI.DeNghiKienNghi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="../../UI/js/Common.js"></script>

    <style type="text/css">
        .Col1 {
            width: 125px;
        }

        .Col2 {
            width: 260px;
        }

        .Col3 {
            width: 145px;
        }

        .Col4 {
            width: 250px;
        }

        .Drop1Col {
            width: 250px;
        }

        .Drop3Col {
            width: 668px;
        }

        .txtCalendar {
            width: 110px;
        }

        .d-file-upload div input {
            border: solid 1px #cccccc;
            border-radius: 4px;
            height: 20px;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #044271;
            padding: 2px 3px;
            text-indent: 3px;
        }

        .d-not-vaild {
            border: solid 1px red !important;
        }

        .d-validator-message {
            color: red;
        }

        .mt-2 {
            margin-top: 5px;
        }
        /*        table, th, td {
  border: 1px solid;
}*/
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddDeNghi" Value="1" runat="server" />
    <asp:HiddenField ID="hddLoaiAn" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddFileid" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">

            <div class="boxchung">
                <h4 class="tleboxchung">
                    <asp:Label runat="server" ID="lbTitle" Text="Thông tin đề nghị/kiến nghị"></asp:Label>
                </h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td colspan="4">
                                <asp:RadioButtonList ID="rdbLoai" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbLoai_SelectedIndexChanged">
                                    <asp:ListItem Value="1" Text="Đề nghị" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Kiến nghị"></asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <asp:TextBox ID="txtKienNghiID" runat="server" Visible="false" />
                        <asp:Panel ID="pnlDeNghi" runat="server">
                            <tr>
                                <td class="Col1">Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdbHinhThucNhanDon" CssClass="d-validator-required" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Ngày viết trên đơn<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayTrenDon" runat="server"
                                        AutoPostBack="True" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayTrenDonCalendarExtender" runat="server" TargetControlID="txtNgayTrenDon" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="txtNgayTrenDonMaskedEditExtender" runat="server" TargetControlID="txtNgayTrenDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="Col3">Ngày đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayDeNghi" runat="server"
                                        AutoPostBack="True" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayDeNghi" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayDeNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Người đề nghị</td>
                                <td class="Col2">
                                    <asp:DropDownList ID="ddlNguoiDeNghi" CssClass="chosen-select Drop1Col" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlNguoiDeNghi_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td class="Col3">Tư cách đương sự</td>
                                <td>
                                    <asp:DropDownList ID="ddlTuCachDuongSu" CssClass="chosen-select Drop1Col" runat="server" AutoPostBack="True">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Số QĐ</td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlQuyetDinh" CssClass="chosen-select Drop3Col" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlQuyetDinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Ngày QĐ</td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtNgayQĐ" runat="server" Enabled="false"
                                        AutoPostBack="True" CssClass="user txtCalendar" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQĐ" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQĐ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="Col3">Toà án ra QĐ</td>
                                <td>
                                    <asp:DropDownList ID="ddlToaAnRaQD" Width="250px" Enabled="false" CssClass="chosen-select Drop3Col" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlQuyetDinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Nội dung đề nghị</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoiDungDeNghi" CssClass="user" runat="server" Width="660px" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <asp:Panel ID="pnZonekythuong" runat="server">
                                    <td class="Col1">Tệp đính kèm</td>
                                    <td colspan="3">
                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                        <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                        <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" CssClass="d-file-upload" />
                                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                         <asp:LinkButton ID="lbtDownloadDN" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                    </td>
                                </asp:Panel>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnlKienNghi" runat="server" Visible="false" ChildrenAsTriggers="true" ClientIDMode="AutoID">
                            <tr>
                                <td class="Col1">Toà án ra QĐ</td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlKNToaAnRaQĐ" Width="660px" CssClass="chosen-select Drop3Col" runat="server" AutoPostBack="True" Enabled="false">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Số QĐ</td>
                                <td class="Col2">
                                    <asp:DropDownList ID="ddlKNQuyetDinh" CssClass="chosen-select Drop1Col" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlKNQuyetDinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td class="Col2">Ngày QĐ</td>
                                <td>
                                    <asp:TextBox ID="txtKNNgayQuyetDinh" runat="server"
                                        AutoPostBack="True" CssClass="user txtCalendar" MaxLength="10" Enabled="false"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtKNNgayQuyetDinh" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtKNNgayQuyetDinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>

                            </tr>
                            <tr>
                                <td class="Col1">Người kiến nghị<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:RadioButtonList ID="rdbKNDonVi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" Enabled="false">
                                        <%--<asp:ListItem Value="0" Text="Chánh án"></asp:ListItem>--%>
                                        <asp:ListItem Value="1" Text="Viện trưởng" Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td class="Col3">Cấp kiến nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbKNCapkiennghi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" Enabled="false">
                                        <asp:ListItem Value="0" Text="Cùng cấp" Selected="True"></asp:ListItem>
                                        <%--<asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>--%>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td class="Col1">Đơn vị kiến nghị<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select Drop3Col d-validator-required" runat="server"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td class="Col1">Số kiến nghị<span class="batbuoc">(*)</span></td>
                                <td class="Col2">
                                    <asp:TextBox ID="txtSoKN" CssClass="user d-validator-required" runat="server" Width="242px"></asp:TextBox>
                                </td>
                                <td class="Col3">Ngày kiến nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayKN" runat="server"
                                        AutoPostBack="True" CssClass="user txtCalendar d-validator-required" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayKN" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayKN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <asp:Panel ID="pnZonekythuongKN" runat="server">
                                    <td class="Col1">Tệp đính kèm</td>
                                    <td colspan="3">
                                        <asp:HiddenField ID="hddFileKySoKN" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionIDKN" runat="server" />
                                        <asp:HiddenField ID="hddURLKSKN" runat="server" />
                                        <asp:HiddenField ID="hddFilePathKN" runat="server" Value="" />
                                        <div id="ZonekythuongKN" style="margin-top: 10px; width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadKN" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKN_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="ThrobberKN" UploadingBackColor="#66CCFF" CssClass="d-file-upload" />
                                            <asp:Image ID="ThrobberKN" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                        <asp:LinkButton ID="lbtDownloadKN" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                    </td>
                                </asp:Panel>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td colspan="1000" style="padding-top: 20px">
                                <asp:Label runat="server" CssClass="d-thongbao" ID="lblThongBao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>


            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return validate()" />

                            <asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>

                            <asp:Panel runat="server" ID="pndata" Visible="true">
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

                                        <asp:BoundColumn DataField="LOAI_TEXT" HeaderText="Đề nghị/Kiến nghị" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HINHTHUC_DONVI_TEXT" HeaderText="Hình thức nhận đơn đề nghị, đơn vị kiến nghị" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOI_DN_CAP_KN_TEXT" HeaderText="Người đề nghị/Cấp kiến nghị" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYDNKN_TEXT" HeaderText="Ngày đề nghị/ kiến nghị" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYQUYETDINH" HeaderText="Ngày QĐ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("FILESID") %>' Visible="true" />
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
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            if (args.get_error() != undefined) {
                args.set_errorHandled(true);
            }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ThongBaoOnHide() {
            $(".d-thongbao").delay(3000).fadeOut(300);
            //validate();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            //CheckKyso();
        }
        function validate() {
            let isPass = true;
            let countRun = 0;
            let total = $(".d-validator-required").length;
            $(".d-validator-required").each(function (index, element) {
                let isVaild = false;
                let type = $(this)[0].localName;
                let value = $(this).val();
                switch (type) {
                    case 'select':
                        if (value == null || value == "" || value == 0) {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    case 'table':
                        //radio
                        $(this).find("input:checked").each(function (index, element) {
                            value = $(element).val();
                            return;
                        });
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                    default:
                        if (value == null || value == "") {
                            isVaild = false;
                        } else {
                            isVaild = true;
                        }
                        break;
                }
                if (!isVaild) {
                    let message = $(this).parent().find('.d-validator-message');
                    if (message.length == 0) {
                        $(this).parent().append(`<span class="d-validator-message mt-1"></span>`);
                        message = $(this).parent().find('.d-validator-message');
                    }
                    message.text("Không được để trống");
                    message.css("display", "unset")
                    message.css("visibility", "inherit")
                    let inputClass = $(this);
                    switch (type) {
                        case 'select':
                            inputClass = $(this).parent().find('a.chosen-single');
                            break;
                        default:
                            break;
                    }
                    inputClass.addClass("d-not-vaild");
                    isPass = false;
                }
                countRun++;
            });
            while (countRun < total)
                break;
            if (isPass == false)
                alert("Hãy điền đầy đủ thông tin");
            return isPass;
        }
        $(document).on('blur', '.d-validator-required', function (event) {
            $(this).parent().find('.d-validator-message').css("display", "none")
            let type = $(this)[0].localName;
            let inputClass = $(this);
            switch (type) {
                case 'select':
                    inputClass = $(this).parent().find('a.chosen-single');
                    break;
                default:
                    break;
            }
            inputClass.removeClass("d-not-vaild");
        });


<%--        var count_file = 0;


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
                $("#<%= cmdThemFileTL.ClientID %>").click();
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }--%>

        //metadata có kiểu List<KeyValue>
        //KeyValue là class { string Key; string Value; }
<%--        function exc_sign_file1() {
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
        }--%>

    </script>
</asp:Content>
