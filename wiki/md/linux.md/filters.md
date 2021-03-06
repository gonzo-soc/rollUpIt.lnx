###### Filter Command
---------------------

1. ##### Cut

    `cut -d: -f1 /etc/passwd`

2. ##### Sort

    `sort -t: -k3,3 -n /etc/group` - sort by group_id 
    `du -sh /usr/* | sort -h` - sort by size    

    `-b` - Ignore leading whitespace -f Sort case-insensitively
    `-h` - Sort “human readable” numbers (e.g., 2MB) 
    `-k` Specify the columns that form the sort key 
    `-n` Compare fields as integer numbers
    `-r` - Reverse sort order
    `-t` - Set field separator (the default is whitespace)
    `-u` - Output only unique records

3. ##### Uniq

    `cut -d: -f7 /etc/passwd | sort | uniq -c`

    where

    `-c` - to count the number of instances of each line;
    `-d` - to show only duplicated
    `-u` - to show only nonduplicated lines

4. ##### wc - char, word, line count 

    `find ~/rui/ -regex '^.*.sh$' -exec wc -l '{}' \; | sort -n`

5. ##### head and tail

    `tail -f -n 100 /var/log/dmesg`

6. ##### Colorized standard commands

    Use [grc](https://github.com/garabik/grc):
    - Clone the project and run `install.sh`: edit `grc` and `grcat` executive scripts to run appropriate `python` bin:

    ```
    /usr/bin/env ${path_to_python}
    ```

    - Add to .bashrc:

    `[[ -s "/etc/profile.d/grc.bashrc" ]] && source /etc/profile.d/grc.bashrc`

7. ##### Grep

    `sudo grep -l mdadm /var/log/*` - `l` is ued to show **paths of files** not matching cases

8. ##### Sed

    - multiline matching:

    ```
    cat ns.yml | sed -rn '/ns:.{0}/{:a;N;/\s{2}rndc_key:/{p;d};ba}'
    ```

    Sed searches `ns:.{0}` then it appends the next line `{:a;N;}`

    - if it matches `\s{2}rndc_key:` it prints then delete the line from the pattern space until the first new line,read the newe line and then restart the cycle

    - if it doesn't match the pattern it reads the next line to the patter buffer: `;ba}` - back to the :a mark

>[!See]
>1. [Multiline technique] (https://vds-admin.ru/sed-and-awk-101-hacks/chapter-7-sed-multi-line-commands-and-loops)
>2. [Manual sed] (https://www.gnu.org/software/sed/manual/sed.html)